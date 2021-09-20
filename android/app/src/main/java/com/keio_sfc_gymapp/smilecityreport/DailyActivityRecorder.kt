package com.keio_sfc_gymapp.smilecityreport

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.AsyncTask
import android.os.Build
import android.os.IBinder
import android.util.Log
import com.google.android.gms.location.ActivityRecognition
import com.google.android.gms.location.ActivityRecognitionClient
import com.google.android.gms.location.DetectedActivity
import com.google.android.gms.tasks.OnFailureListener
import com.google.android.gms.tasks.OnSuccessListener
import com.google.android.gms.tasks.Task
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.concurrent.schedule


class DailyActivityRecorder: Service(), SensorEventListener{

    private lateinit var notificationHelper:NotificationHelper
    private lateinit var sensorManager: SensorManager
    private var stepCounter: Sensor? = null
    private lateinit var activityDetectionReceiver: ActivityDetectionReceiver
    private lateinit var activityRecognitionClient: ActivityRecognitionClient
    private var pendingIntent: PendingIntent? = null
    private lateinit var activityRecognitionService: Intent

    private lateinit var rebootEventReceiver: BroadcastReceiver

    private lateinit var database:SFCGoDB.AppDatabase

    private var latestTotalSteps:Int = 0
    private var latestStepEventTimestamp:Long = 0
    private val saveTrigger = Timer()

    companion object {
        const val ACTIVITY_RECOGNITION_NOTIFY_INTENT_FILTER = "com.smilex.gymapp.notify_intent_filter.activity_recognition"
        const val ACTIVITY_RECOGNITION_NOTIFY_INTENT_ACTIVITY_TYPE = "com.smilex.gymapp.notify_intent.activity_recognition.type"
        const val ACTIVITY_RECOGNITION_NOTIFY_INTENT_ACTIVITY_CONFIDENCE = "com.smilex.gymapp.notify_intent.activity_recognition.confidence"
    }

    public fun setPedometerStatus(context:Context, status:Boolean){
        val data = context.getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE)
        val editor = data.edit()
        editor.putBoolean(Constants.CONFIG_BASE_PATH+".pedometer" , status)
        editor.apply()
    }

    public fun setActivityRecognitionStatus(context:Context, status:Boolean){
        val data = context.getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE)
        val editor = data.edit()
        editor.putBoolean(Constants.CONFIG_BASE_PATH+".activity_recognition" , status)
        editor.apply()
    }

    public fun getPedometerStatus(context:Context):Boolean {
        val pref = context.getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE)
        return pref.getBoolean(Constants.CONFIG_BASE_PATH+".pedometer", true)
    }

    public fun getActivityRecognitionStatus(context:Context):Boolean{
        val pref = context.getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE)
        return pref.getBoolean(Constants.CONFIG_BASE_PATH+".activity_recognition", true)
    }

    override fun onCreate() {
        super.onCreate()

        rebootEventReceiver = RebootEventReceiver()
        var filter = IntentFilter()
        filter.addAction(Intent.ACTION_USER_PRESENT)
        registerReceiver(rebootEventReceiver, filter)

        notificationHelper = NotificationHelper(applicationContext)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        stepCounter = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        
        activityDetectionReceiver = ActivityDetectionReceiver()
        registerReceiver(activityDetectionReceiver, IntentFilter(ACTIVITY_RECOGNITION_NOTIFY_INTENT_FILTER))


        activityRecognitionClient = ActivityRecognition.getClient(applicationContext)
        activityRecognitionService = Intent(applicationContext, ActivityRecognitionService::class.java)

        database = SFCGoDB.AppDatabase.getDatabase(applicationContext)

        val builder: Notification.Builder = notificationHelper.notification
        builder.setContentTitle("日常生活の記録")
        if (getActivityRecognitionStatus(applicationContext) && getPedometerStatus(applicationContext)) {
            builder.setContentText("歩数と移動手段を記録しています")
        } else if (getActivityRecognitionStatus(applicationContext)) {
            builder.setContentText("移動手段を記録しています")
        } else if (getPedometerStatus(applicationContext)) {
            builder.setContentText("歩数を記録しています")
        } else {
            builder.setContentText("停止中")
        }

        if (Build.VERSION.SDK_INT >= 26) {
            startForeground(2, builder.build())
        }else{
            notificationHelper.notify(2, builder)
        }

        saveTrigger.schedule(0, 1000*60) {
            GlobalScope.launch(Dispatchers.Main) {
                save()
            }
        }
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null;
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (getPedometerStatus(applicationContext)){
            if (this.stepCounter != null) sensorManager.registerListener(this, stepCounter, SensorManager.SENSOR_DELAY_FASTEST);
        }

        if (getActivityRecognitionStatus(applicationContext)){
            pendingIntent = PendingIntent.getService(
                    applicationContext,
                    1,
                    activityRecognitionService,
                    PendingIntent.FLAG_CANCEL_CURRENT
            )
            val task: Task<Void> = activityRecognitionClient.requestActivityUpdates(1000*60, pendingIntent)
            task.addOnSuccessListener(OnSuccessListener<Void?> {
                Log.d(DailyActivityRecorder::class.simpleName, "success")
            })
            task.addOnFailureListener(OnFailureListener {
                Log.d(DailyActivityRecorder::class.simpleName, "failure")
            })
        }


        return START_STICKY //super.onStartCommand(intent, flags, startId)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (this.stepCounter != null) sensorManager.unregisterListener(this, stepCounter)
        if (pendingIntent!=null){
            activityRecognitionClient.removeActivityUpdates(pendingIntent)
        }
        notificationHelper.cancel(2)
        unregisterReceiver(activityDetectionReceiver)
        unregisterReceiver(rebootEventReceiver)
        save()
        saveTrigger.cancel()
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
//        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun onSensorChanged(sensorEvent: SensorEvent?) {
        val sensorType = sensorEvent?.sensor?.type
        if (sensorType == Sensor.TYPE_STEP_COUNTER){
            // keep the current step event condition
            this.latestTotalSteps = sensorEvent.values[0].toInt()
            this.latestStepEventTimestamp = sensorEvent.timestamp
        }
    }

    private fun save(){
        AsyncTask.execute {
            /* Save a step event */
            if (latestTotalSteps != 0 ){
                val lastStepEvent = database.pedometerDao().getLast()
                val now = System.currentTimeMillis()
                if (lastStepEvent == null) {
                    val pedometer = SFCGoDB.Pedometer(
                            id = 0,
                            startTimestamp = now - (1000 * 60),
                            endTimestamp = now,
                            totalSteps =  this.latestTotalSteps,
                            steps = this.latestTotalSteps,
                            isSynced =  false
                    )
                    database.pedometerDao().insertAll(pedometer)
                }else{
                    val pedometer = SFCGoDB.Pedometer(
                            id = 0,
                            startTimestamp = lastStepEvent.endTimestamp,
                            endTimestamp = now,
                            totalSteps =  this.latestTotalSteps,
                            steps = this.latestTotalSteps - lastStepEvent.totalSteps,
                            isSynced =  false
                    )
                    database.pedometerDao().insertAll(pedometer)
                }
            }else{
                Log.d("DailyActivityMonitor", "Skip:: latestTotalSteps is 0");
            }

            /* Save an Activity Recognition Event */
            val activityType = activityDetectionReceiver.latestActivityType
            val activityConfidence = activityDetectionReceiver.latestActivityConfidence
            var activityEvent = SFCGoDB.ActivityRecognition(
                id = 0,
                timestamp = System.currentTimeMillis(),
                activities = "",
                activityName = getNameFromType(activityType),
                activityType = activityType,
                confidence = activityConfidence,
                isSynced =  false
            )
            when (activityType) {
                DetectedActivity.IN_VEHICLE -> activityEvent.automotive = 1
                DetectedActivity.ON_BICYCLE -> activityEvent.cycling = 1
                DetectedActivity.ON_FOOT -> activityEvent.walking = 1
                DetectedActivity.STILL -> activityEvent.stationary = 1
                DetectedActivity.UNKNOWN -> activityEvent.unknown = 1
                DetectedActivity.RUNNING -> activityEvent.running = 1
                DetectedActivity.WALKING -> activityEvent.walking = 1
            }
            val database = SFCGoDB.AppDatabase.getDatabase(applicationContext)
            database.activityRecognitionDao().insert(activityEvent)

        }
    }

    private fun getNameFromType(activityType: Int): String {
        when (activityType) {
            DetectedActivity.IN_VEHICLE -> return "automotive"
            DetectedActivity.ON_BICYCLE -> return "cycling"
            DetectedActivity.ON_FOOT -> return "walking"
            DetectedActivity.STILL   -> return "stationary"
            DetectedActivity.UNKNOWN -> return "unknown"
            DetectedActivity.TILTING -> return "tilting"
            DetectedActivity.WALKING -> return "walking"
            DetectedActivity.RUNNING -> return "running"
        }
        return "unknown"
    }


    private class ActivityDetectionReceiver : BroadcastReceiver() {

        var latestActivityType:Int = -1
        var latestActivityConfidence:Int = -1

        override fun onReceive(context: Context, intent: Intent) {
            latestActivityType       = intent.getIntExtra(ACTIVITY_RECOGNITION_NOTIFY_INTENT_ACTIVITY_TYPE, -1)
            latestActivityConfidence = intent.getIntExtra(ACTIVITY_RECOGNITION_NOTIFY_INTENT_ACTIVITY_CONFIDENCE, -1)

        }
    }


}