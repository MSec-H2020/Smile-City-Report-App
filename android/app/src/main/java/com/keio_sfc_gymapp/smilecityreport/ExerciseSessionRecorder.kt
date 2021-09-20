package com.keio_sfc_gymapp.smilecityreport

import android.app.Notification
import android.app.Service
import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.AsyncTask
import android.os.Build
import android.os.IBinder
import android.util.Log
import com.google.android.gms.location.*
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.collections.HashMap
import kotlin.concurrent.schedule


class ExerciseSessionRecorder: Service(), SensorEventListener {

    private lateinit var sensorManager: SensorManager

    private var lAccSensor: Sensor? = null
    private var gyroscope: Sensor?  = null
    private var barometer: Sensor?  = null
    private lateinit var locationProvider: FusedLocationProviderClient
    private lateinit var mLocationRequest: LocationRequest
    private lateinit var notificationHelper:NotificationHelper
    private lateinit var database:SFCGoDB.AppDatabase

    private var lAccBuffer: MutableList<HashMap<String,Any>> = mutableListOf()
    private var gyroBuffer: MutableList<HashMap<String,Any>> = mutableListOf()
    private var barometerBuffer:MutableList<HashMap<String,Any>> = mutableListOf()

    private val gson = Gson();
    private var exerciseSessionId:Long = System.currentTimeMillis()

    private val saveTrigger = Timer()
    private var elapsedSeconds = 0
    private val sensingInterval = (1.0/30.0*1000000).toInt()

    companion object {
        // const val EXERCISE_SESSION_NOTIFY_INTENT_FILTER = "com.smilex.gymapp.notify_intent_filter.exercise_session"
        const val EXERCISE_SESSION_NOTIFY_INTENT_ACTION = "com.smilex.gymapp.notify_intent.exercise_session.action"
        const val EXERCISE_SESSION_NOTIFY_INTENT_DATA   = "com.smilex.gymapp.notify_intent.exercise_session.data"
    }

    override fun onCreate() {
        super.onCreate()

        notificationHelper = NotificationHelper(applicationContext)
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager

        database = SFCGoDB.AppDatabase.getDatabase(applicationContext)

        lAccSensor   = sensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION)
        gyroscope    = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
        barometer    = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE)
        locationProvider = LocationServices.getFusedLocationProviderClient(this)
        mLocationRequest = LocationRequest()

        saveTrigger.schedule(0, 1000) {
            val builder: Notification.Builder = notificationHelper.notification
            if (elapsedSeconds >= 60) {
                val min:Int = (elapsedSeconds/60)
                val sec:Int = (elapsedSeconds%60)
                builder.setContentTitle("運動の計測: $min 分 $sec 秒経過")
            }else{
                builder.setContentTitle("運動の計測: $elapsedSeconds 秒経過")
            }
            builder.setContentText("加速度・角速度・位置情報・気圧センサを使用中です")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForeground(1, builder.build())
            }else{
                notificationHelper.notify(1, builder)
            }
            // 1分おきに保存
            if (elapsedSeconds > 0 && elapsedSeconds % 10 ==0 ) {
                GlobalScope.launch(Dispatchers.Main) {
                    saveBufferedData()
                }
            }
            elapsedSeconds += 1
        }

    }

    override fun onBind(p0: Intent?): IBinder? {
        return null;
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (lAccSensor != null ) sensorManager.registerListener(this, lAccSensor, sensingInterval)
        if (gyroscope  != null ) sensorManager.registerListener(this, gyroscope, sensingInterval)
        if (barometer  != null ) sensorManager.registerListener(this, barometer, sensingInterval)

        startUpdatingLocation()

        return super.onStartCommand(intent, flags, startId)
    }

    override fun onDestroy() {
        saveBufferedData()
        saveTrigger.cancel()
        if (lAccSensor != null ) sensorManager.unregisterListener(this, lAccSensor)
        if (gyroscope  != null ) sensorManager.unregisterListener(this, gyroscope)
        if (barometer  != null ) sensorManager.unregisterListener(this, barometer)

        notificationHelper.cancel(1)
        stopUpdatingLocation()

        super.onDestroy()
    }

    ////////////// sensors

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {

    }

    override fun onSensorChanged(sensorEvent: SensorEvent?) {
        // Log.d("sensor", sensorEvent?.timestamp?.toDouble().toString())
        val timestamp = System.currentTimeMillis()
        if (sensorEvent != null) {
            when (sensorEvent.sensor?.type) {
                Sensor.TYPE_PRESSURE -> {
                    val sensorData:HashMap<String,Any> = hashMapOf(
                        "timestamp" to timestamp,
                        "double_values_0" to sensorEvent.values[0],
                        "accuracy" to sensorEvent.accuracy
                    )
                    val data:HashMap<String,Any> = hashMapOf(
                        "sensorName" to "barometer",
                        "data" to sensorData
                    )
                    this.broadcastNotification(data)
                    lAccBuffer.add(sensorData)
                    // Log.d("sensor_data", data.toString());
                }
                Sensor.TYPE_GYROSCOPE -> {
                    val sensorData:HashMap<String,Any> = hashMapOf(
                        "timestamp" to timestamp,
                        "double_values_0" to sensorEvent.values[0],
                        "double_values_1" to sensorEvent.values[1],
                        "double_values_2" to sensorEvent.values[2],
                        "accuracy" to sensorEvent.accuracy
                    )
                    val data:HashMap<String,Any> = hashMapOf(
                        "sensorName" to "gyroscope",
                        "data" to sensorData
                    )
                    this.broadcastNotification(data)
                    gyroBuffer.add(sensorData)
                }
                Sensor.TYPE_LINEAR_ACCELERATION -> {
                    val sensorData:HashMap<String,Any> = hashMapOf(
                        "timestamp" to timestamp,
                        "double_values_0" to sensorEvent.values[0],
                        "double_values_1" to sensorEvent.values[1],
                        "double_values_2" to sensorEvent.values[2],
                        "accuracy" to sensorEvent.accuracy
                    )
                    val data:HashMap<String,Any> = hashMapOf(
                        "sensorName" to "linear_accelerometer",
                        "data" to sensorData
                    )
                    this.broadcastNotification(data)
                    barometerBuffer.add(sensorData)
                }
            }
        }else{
            Log.w(ExerciseSessionRecorder::class.simpleName, "sensorEvent is null")
        }
    }

    private fun saveBufferedData(){

        val lAccJsonStr = gson.toJson(lAccBuffer)
        AsyncTask.execute {
            val entity = SFCGoDB.LinearAccelerometer(
                id=0,
                sessionId = exerciseSessionId,
                timestamp = System.currentTimeMillis(),
                data =lAccJsonStr,
                label = "",
                isSynced = false
            )
            database.linearAccelerometerDao().insertAll(entity)
        }
        lAccBuffer.clear()


        val gyroJsonStr = gson.toJson(gyroBuffer)
        AsyncTask.execute {
            val entity = SFCGoDB.Gyroscope(
                id=0,
                sessionId = exerciseSessionId,
                timestamp = System.currentTimeMillis(),
                data = gyroJsonStr,
                label = "",
                isSynced = false
            )
            database.gyroscopeDao().insertAll(entity)
        }
        gyroBuffer.clear()


        val barometerJsonStr = gson.toJson(barometerBuffer)
        AsyncTask.execute {
            val entity = SFCGoDB.Barometer(
                id=0,
                sessionId = exerciseSessionId,
                timestamp = System.currentTimeMillis(),
                data = barometerJsonStr,
                label = "",
                isSynced = false
            )
            database.barometerDao().insertAll(entity)
        }
        barometerBuffer.clear()
    }

    private fun startUpdatingLocation() {
        mLocationRequest = buildLocationRequest()
        locationProvider.requestLocationUpdates(mLocationRequest, mLocationCallback, null)
    }

    private fun stopUpdatingLocation(){
        locationProvider.removeLocationUpdates(mLocationCallback)
    }

    private val mLocationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult?) {
            super.onLocationResult(locationResult)
            // Log.d("location", locationResult.toString())
            if (locationResult != null) {
                val lastLocation = locationResult.lastLocation
                var data:HashMap<String,Any> = hashMapOf(
                        "sensorName" to "locations",
                        "data"       to hashMapOf(
                        "timestamp"  to System.currentTimeMillis(),
                        "double_latitude"  to lastLocation.latitude,
                        "double_longitude" to lastLocation.longitude,
                        "double_latitude"  to lastLocation.latitude,
                        "double_bearing"   to lastLocation.bearing,
                        "double_speed"     to lastLocation.speed,
                        "double_altitude"  to lastLocation.altitude,
                        "accuracy" to lastLocation.accuracy,
                        "provider" to lastLocation.provider,
                        "label"    to ""
                    )
                )
                broadcastNotification(data)
            }else{
                Log.d(ExerciseSessionRecorder::class.simpleName, "LocationResult is null")
            }
        }
    }

    private fun buildLocationRequest(): LocationRequest {
        // https://developers.google.com/android/reference/com/google/android/gms/location/LocationRequest
        val req = LocationRequest();
        req.priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        req.interval = 1000
        req.fastestInterval = 1000
        return req
    }

    fun broadcastNotification(data:HashMap<String,Any>){
        val broadcast = Intent()
        broadcast.putExtra(EXERCISE_SESSION_NOTIFY_INTENT_DATA, data);
        broadcast.action = EXERCISE_SESSION_NOTIFY_INTENT_ACTION;
        baseContext.sendBroadcast(broadcast);
    }

}