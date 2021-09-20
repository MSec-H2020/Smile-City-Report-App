package com.keio_sfc_gymapp.smilecityreport

import android.R
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.ContextWrapper
import android.os.Build


class NotificationHelper(base: Context?) : ContextWrapper(base) {

    private val manager: NotificationManager by lazy {
        getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    val notification: Notification.Builder
        get() {
            var builder: Notification.Builder
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                builder = Notification.Builder(this, CHANNEL_GENERAL_ID)
            } else {
                builder = Notification.Builder(this)
            }

            return builder.setContentTitle("MySensors")
                .setContentText("Hello World!")
                .setSmallIcon(R.mipmap.sym_def_app_icon)
        }

    fun notify(id: Int, builder: Notification.Builder) {
        manager.notify(id, builder.build())
    }

    fun cancel(id:Int){
        manager.cancel(id)
    }

    companion object {
        private const val CHANNEL_GENERAL_ID = "general"
    }

    init {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_GENERAL_ID,
                "General Notifications",
                NotificationManager.IMPORTANCE_LOW
            )
            manager.createNotificationChannel(channel)
        }
    }
}