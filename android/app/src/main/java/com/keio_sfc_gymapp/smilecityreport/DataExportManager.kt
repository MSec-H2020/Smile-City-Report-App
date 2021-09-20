package com.keio_sfc_gymapp.smilecityreport

import android.content.Context
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.os.AsyncTask
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.content.FileProvider
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.*

class DataExportManager(val context: Context) {

    private val database: SFCGoDB.AppDatabase = SFCGoDB.AppDatabase.getDatabase(context)
    private val datetimeFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
    private val dateFormat     = SimpleDateFormat("yyyy-MM-dd")
    private var mainThreadHandler: Handler? = null

    fun exportSensorData(sensorName: String, start:Long?=null, end:Long?=null) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            AsyncTask.execute {
                val fileName = "$sensorName.tsv"
                // create a CSV file
                context.openFileOutput(fileName, Context.MODE_PRIVATE).use {
                    writeHeader(it, sensorName)
                    writeBody(it,   sensorName)
                    it.close()
                }
                val shareFile = File(context.filesDir.toString() + "/$fileName")
                this.shareFile(shareFile)
            }
        }
    }

    private fun writeHeader(fileOutputStream: FileOutputStream, sensorName: String){
        var headerRow = ""
        when (sensorName) {
            "pedometer" -> {
                val header = arrayOf("timestamp", "datetime", "date",
                        "year", "month", "day", "weekday",
                        "hour", "minute", "second", "steps")
                headerRow = this.convertLineToRow(header, "\t", "\n")
            }
            "activity_recognition" -> {
                val header = arrayOf("timestamp", "datetime", "date",
                        "year", "month", "day", "weekday",
                        "hour", "minute", "second", "activities", "confidence")
                headerRow = this.convertLineToRow(header, "\t", "\n")
            }
            else -> {
                Log.e(DataExportManager::class.simpleName, "Unsupported Sensor Name");
            }
        }
        fileOutputStream.write(headerRow.toByteArray())
    }

    private fun writeBody(fileOutputStream: FileOutputStream, sensorName: String){
        val calender = Calendar.getInstance()
        when (sensorName) {
            "pedometer" -> {
                val steps = database.pedometerDao().getAll()
                if (steps != null){
                    for (step in steps) {
                        var date = Date(step.startTimestamp)
                        calender.time = date
                        val values = arrayOf(
                                step.startTimestamp.toString(),
                                datetimeFormat.format(date),
                                dateFormat.format(date),
                                calender.get(Calendar.YEAR).toString(),
                                (calender.get(Calendar.MONTH)+1).toString(),
                                calender.get(Calendar.DAY_OF_MONTH).toString(),
                                calender.get(Calendar.DAY_OF_WEEK).toString(),
                                calender.get(Calendar.HOUR_OF_DAY).toString(),
                                calender.get(Calendar.MINUTE).toString(),
                                calender.get(Calendar.SECOND).toString(),
                                step.steps.toString()
                        )
                        val valuesRow = convertLineToRow(values, "\t", "\n")
                        fileOutputStream.write(valuesRow.toByteArray())
                    }
                }
            }
            "activity_recognition" -> {
                val activityRecognitions = database.activityRecognitionDao().getAll()
                if (activityRecognitions != null){
                    for (activityRecognition in activityRecognitions) {
                        var date = Date(activityRecognition.timestamp)
                        calender.time = date
                        val values = arrayOf(
                                activityRecognition.timestamp.toString(),
                                datetimeFormat.format(date),
                                dateFormat.format(date),
                                calender.get(Calendar.YEAR).toString(),
                                (calender.get(Calendar.MONTH)+1).toString(),
                                calender.get(Calendar.DAY_OF_MONTH).toString(),
                                calender.get(Calendar.DAY_OF_WEEK).toString(),
                                calender.get(Calendar.HOUR_OF_DAY).toString(),
                                calender.get(Calendar.MINUTE).toString(),
                                calender.get(Calendar.SECOND).toString(),
                                activityRecognition.activityName,
                                activityRecognition.confidence.toString()
                        )
                        val valuesRow = convertLineToRow(values, "\t", "\n")
                        fileOutputStream.write(valuesRow.toByteArray())
                    }
                }
            }
        }
    }

    private fun shareFile(file:File){
        mainThreadHandler = Handler(Looper.getMainLooper())
        mainThreadHandler?.post {
            val fileUri = FileProvider.getUriForFile(
                    context,
                    context.packageName.toString() + ".provider",
                    file
            )

            val sendIntent: Intent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_STREAM, fileUri );
                type = "text/*"
            }

            val shareIntent = Intent.createChooser(sendIntent, file.name)
            shareIntent.flags = FLAG_ACTIVITY_NEW_TASK
            context.startActivity(shareIntent)
        }
    }

    private fun convertLineToRow(line:Array<String>, separator:String, lastCharacter:String):String {
        return (line.reduce{temp, value ->
            if (temp == "") {
                temp + ""
            }else{
                temp + separator + value
            }
        })+lastCharacter
    }
}