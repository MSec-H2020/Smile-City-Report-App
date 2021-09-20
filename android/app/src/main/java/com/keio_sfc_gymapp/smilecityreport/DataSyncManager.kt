package com.keio_sfc_gymapp.smilecityreport

import android.app.IntentService
import android.content.Context
import android.content.Intent
import android.os.AsyncTask
import android.os.Build
import android.util.Log

import com.github.kittinunf.fuel.httpPost
import com.google.gson.Gson


class DataSyncManager: IntentService(DataSyncManager::class.simpleName) {

    private lateinit var database:SFCGoDB.AppDatabase
    private val endpoint = Constants.STUDY_LINK
    private val basePath = Constants.CONFIG_BASE_PATH
    private lateinit var deviceId:String
    private val gson = Gson();

    override fun onHandleIntent(p0: Intent?) {

    }

    override fun onCreate() {
        super.onCreate()
        deviceId = Constants.getDeviceId(applicationContext)
        database = SFCGoDB.AppDatabase.getDatabase(applicationContext)
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        this.syncAllData()
        return super.onStartCommand(intent, flags, startId)
    }

    private fun checkDeviceRegistrationStatus():Boolean{
        val pref = getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE)
        return pref.getBoolean(Constants.CONFIG_BASE_PATH+".device_registration", false)
    }

    private fun compDeviceRegistration(){
        getSharedPreferences(Constants.CONFIG_BASE_PATH, Context.MODE_PRIVATE).edit().apply {
            putBoolean(Constants.CONFIG_BASE_PATH+".device_registration" , true)
            commit()
        }
    }

    private fun syncAllData(){
        AsyncTask.execute {

            if (!checkDeviceRegistrationStatus()){
                val deviceInfo = listOf("device_id" to deviceId, "data" to arrayListOf(getDeviceInfo()))
                // val createDeviceTable = (endpoint+"/aware_device/create_table").httpPost(deviceInfo).response()
                val triple = (endpoint+"/aware_device/insert").httpPost(deviceInfo).response()
                if (triple.second.statusCode == 200) {
                    compDeviceRegistration()
                }
            }

            syncPedometer()
            syncActivityRecognition()
            syncLAcc()
            syncGyro()
            syncBarometer()

            stopSelf()
        }
    }

    private fun getDeviceInfo():String{
        val info = hashMapOf(
            "board" to Build.BOARD,
            "bootloader" to Build.BOOTLOADER,
            "display" to Build.DISPLAY,
            "hardware" to Build.HARDWARE,
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "product" to Build.PRODUCT,
            "type" to Build.TYPE,
            "user" to Build.USER,
            "os" to "Android",
            "version_sdk_int" to Build.VERSION.SDK_INT,
            "version_release" to Build.VERSION.RELEASE,
            "version_base_os" to Build.VERSION.BASE_OS,
            "version_codename" to Build.VERSION.CODENAME,
            "version_incremental" to Build.VERSION.INCREMENTAL
        )
        return gson.toJson(info)
    }

    private fun syncPedometer(){
        val unsyncedPedometerCount = database.pedometerDao().countUnsynced()
        if (unsyncedPedometerCount > 0) {
            // Log.d("pedometer", unsyncedPedometerCount.toString())
            val limit = 500
            val repeat = (unsyncedPedometerCount/limit)
            for (i in 0..repeat) {
                val dataArray = mutableListOf<Any>()
                val unsyncedRecords = database.pedometerDao().getUnsynced(limit)
                // Log.d("pedometer", unsyncedRecords.toString())
                for (uRecord in unsyncedRecords) {
                    dataArray.add(hashMapOf(
                        "timestamp" to uRecord.startTimestamp,
                        "device_id" to deviceId,
                        "end_timestamp" to uRecord.endTimestamp,
                        "number_of_steps" to uRecord.steps,
                        "total_steps" to uRecord.totalSteps
                    ))
                }
                val postData = listOf("device_id" to deviceId, "data" to gson.toJson(dataArray))
                val triple = (endpoint+"/plugin_android_pedometer/insert").httpPost(postData).response()
                if (triple.second.statusCode == 200) {
                    // Log.d("pedometer", triple.toString())
                    val ids = unsyncedRecords.map{ it.id}
                    for (id in ids) {
                        database.pedometerDao().updateSyncStatus(id, true)
                    }
                }else{
                    break
                }
            }
        }
    }

    private fun syncActivityRecognition(){
        val unsyncedARCount = database.activityRecognitionDao().countUnsynced()
        if (unsyncedARCount > 0) {
            val limit = 500
            val repeat = (unsyncedARCount/limit)
            for (i in 0..repeat) {
                val dataArray = mutableListOf<Any>()
                val unsyncedRecords = database.activityRecognitionDao().getUnsynced(limit)
                for (uRecord in unsyncedRecords) {
                    dataArray.add(hashMapOf(
                        "timestamp" to uRecord.timestamp,
                        "device_id" to deviceId,
                        "data" to uRecord.activities,
                        "activities" to "["+uRecord.activityName+"]",
                        "confidence" to uRecord.confidence,
                        "activityType" to uRecord.activityType,
                        "automotive" to uRecord.automotive,
                        "cycling" to uRecord.cycling,
                        "walking" to uRecord.walking,
                        "stationary" to uRecord.stationary,
                        "unknown" to uRecord.unknown,
                        "running" to uRecord.running
                    ))
                }
                val postData = listOf("device_id" to deviceId, "data" to gson.toJson(dataArray))
                val triple = (endpoint+"/plugin_ios_activity_recognition/insert").httpPost(postData).response()
                if (triple.second.statusCode == 200) {
                    val ids = unsyncedRecords.map{ it.id}
                    for (id in ids) {
                        database.activityRecognitionDao().updateSyncStatus(id, true)
                    }
                }else{
                    break
                }
            }
        }
    }

    private fun syncLAcc(){
        val records = database.linearAccelerometerDao().getUnsyncedAll()
        for (record in records) {
            val postData = listOf("device_id" to deviceId, "data" to record.data)
            // val createTable = (endpoint+"/linear_accelerometer/create_table").httpPost(postData).response()
            val triple = (endpoint+"/linear_accelerometer/insert").httpPost(postData).response()
            if (triple.second.statusCode == 200) {
                database.linearAccelerometerDao().updateSyncStatus(record.id, true)
            }else{
                break
            }
        }
    }

    private fun syncGyro(){

        val gyroRecords = database.gyroscopeDao().getUnsyncedAll()
        // val count = gyroRecords.size
        for (record in gyroRecords) {
            val postData = listOf("device_id" to deviceId, "data" to record.data)
            // val createTable = (endpoint+"/gyroscope/create_table").httpPost(postData).response()
            val triple = (endpoint+"/gyroscope/insert").httpPost(postData).response()
            if (triple.second.statusCode == 200) {
                database.gyroscopeDao().updateSyncStatus(record.id, true)
            }else{
                break
            }
        }
    }

    private fun syncBarometer(){
        val barometerRecords = database.barometerDao().getUnsyncedAll()
        for (record in barometerRecords) {
            val postData = listOf("device_id" to deviceId, "data" to record.data)
//                val createTable = (endpoint+"/barometer/create_table").httpPost(postData).response()
            val triple = (endpoint+"/barometer/insert").httpPost(postData).response()
            if (triple.second.statusCode == 200) {
                database.barometerDao().updateSyncStatus(record.id, true)
            }else{
                break
            }
        }

    }


    override fun onDestroy() {
        super.onDestroy()
    }

}