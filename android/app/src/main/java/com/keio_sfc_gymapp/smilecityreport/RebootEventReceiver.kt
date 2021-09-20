package com.keio_sfc_gymapp.smilecityreport

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class RebootEventReceiver: BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {

        when (intent?.action) {
            Intent.ACTION_LOCKED_BOOT_COMPLETED -> {
                val startService = Intent(context?.applicationContext, DailyActivityRecorder::class.java)
                context?.startForegroundService(startService)
            }
        }
    }
}