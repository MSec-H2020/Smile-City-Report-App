package com.keio_sfc_gymapp.smilecityreport

import android.app.IntentService
import android.content.Intent
import android.os.IBinder
import android.util.Log
import androidx.annotation.Nullable
import com.google.android.gms.location.ActivityRecognitionResult

class ActivityRecognitionService: IntentService(ActivityRecognitionService::class.simpleName) {

    override fun onCreate() {
        super.onCreate()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return super.onBind(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onHandleIntent(@Nullable intent: Intent?) {
        val result = ActivityRecognitionResult.extractResult(intent)
        val mostProbableActivity = result.mostProbableActivity
        val notifyIntent = Intent(DailyActivityRecorder.ACTIVITY_RECOGNITION_NOTIFY_INTENT_FILTER)
        for (activity in result.probableActivities ) {
            Log.d(ActivityRecognitionService::class.simpleName, activity.toString())
        }
        notifyIntent.setPackage(packageName)
        notifyIntent.putExtra(DailyActivityRecorder.ACTIVITY_RECOGNITION_NOTIFY_INTENT_ACTIVITY_TYPE, mostProbableActivity.type)
        notifyIntent.putExtra(DailyActivityRecorder.ACTIVITY_RECOGNITION_NOTIFY_INTENT_ACTIVITY_CONFIDENCE, mostProbableActivity.confidence)
//        notifyIntent.putExtra("notify_activities",    result.mostProbableActivity)

        // result.
//        var activities = mutableListOf<HashMap<String,Any>>()
//        for (activity in result.probableActivities) {
//            activities.add(hashMapOf("activity":)
//        }
//        Log.d(ActivityRecognitionService::class.simpleName, result.mostProbableActivity.toString());

        sendBroadcast(notifyIntent)
    }
}