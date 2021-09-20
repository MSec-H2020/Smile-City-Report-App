package com.keio_sfc_gymapp.smilecityreport

import android.content.Context
import androidx.room.*


// https://developer.android.com/jetpack/androidx/releases/room?hl=ja#declaring_dependencies

class SFCGoDB{

    @Entity
    data class Location(
        @PrimaryKey(autoGenerate = true) val id: Int,
        @ColumnInfo(name = "timestamp") val timestamp: Long,
        @ColumnInfo(name = "session_id") val sessionId: Long,
        @ColumnInfo(name = "data") val data:String,
        @ColumnInfo(name= "label") val label:String,
        @ColumnInfo(name = "is_synced") val isSynced: Boolean
    )

    @Dao
    interface LocationDao {
        @Query("SELECT * FROM location")
        fun getAll(): List<Location>

        @Query("SELECT * FROM location WHERE session_id IN (:sessionIds)")
        fun loadAllByIds(sessionIds: IntArray): List<Location>

        @Insert
        fun insertAll(vararg location: Location)

        @Delete
        fun delete(location: Location)
    }

    //////////////

    @Entity
    data class LinearAccelerometer(
        @PrimaryKey(autoGenerate = true) val id:Int,
        @ColumnInfo(name = "timestamp" ) val timestamp: Long,
        @ColumnInfo(name = "session_id") val sessionId: Long,
        @ColumnInfo(name = "data")  val data: String,
        @ColumnInfo(name=  "label") val label:String,
        @ColumnInfo(name = "is_synced") val isSynced: Boolean
    )

    @Dao
    interface LinearAccelerometerDao {
        @Query("SELECT * FROM linearaccelerometer")
        fun getAll(): List<LinearAccelerometer>

        @Query("SELECT * FROM linearaccelerometer WHERE session_id IN (:sessionIds)")
        fun loadAllByIds(sessionIds: IntArray): List<LinearAccelerometer>

        @Query("SELECT * FROM linearaccelerometer WHERE is_synced IS 0 LIMIT :limit")
        fun getUnsynced(limit:Int): List<LinearAccelerometer>

        @Query("SELECT * FROM linearaccelerometer WHERE is_synced IS 0")
        fun getUnsyncedAll(): List<LinearAccelerometer>

        @Query("SELECT count(*) FROM linearaccelerometer WHERE is_synced IS 0")
        fun countUnsynced():Int

        @Query("UPDATE linearaccelerometer SET is_synced = :status where id=:id")
        fun updateSyncStatus( id: Int, status:Boolean)

        @Update
        fun updateAll(vararg lAccs: LinearAccelerometer)

        @Insert
        fun insertAll(vararg lAcc: LinearAccelerometer)

        @Delete
        fun delete(lAcc: LinearAccelerometer)
    }

    //////////////

    @Entity
    data class Gyroscope(
        @PrimaryKey(autoGenerate = true) val id:Int,
        @ColumnInfo(name = "timestamp" ) val timestamp: Long,
        @ColumnInfo(name = "session_id") val sessionId: Long,
        @ColumnInfo(name = "data") val data: String,
        @ColumnInfo(name= "label") val label:String,
        @ColumnInfo(name = "is_synced") val isSynced: Boolean
    )

    @Dao
    interface GyroscopeDao{
        @Query("SELECT * FROM gyroscope")
        fun getAll(): List< Gyroscope>

        @Query("SELECT * FROM gyroscope WHERE session_id IN (:sessionIds)")
        fun loadAllByIds(sessionIds: IntArray): List<Gyroscope>

        @Query("SELECT * FROM gyroscope WHERE is_synced IS 0 LIMIT :limit")
        fun getUnsynced(limit:Int): List<Gyroscope>

        @Query("SELECT * FROM gyroscope WHERE is_synced IS 0")
        fun getUnsyncedAll(): List<Gyroscope>

        @Query("SELECT count(*) FROM gyroscope WHERE is_synced IS 0")
        fun countUnsynced():Int

        @Insert
        fun insertAll(vararg gyroscope:  Gyroscope)

        @Query("UPDATE gyroscope SET is_synced = :status where id=:id")
        fun updateSyncStatus(id: Int, status:Boolean)

        @Update
        fun updateAll(vararg gyroscope: Gyroscope)

        @Delete
        fun delete(gyroscope:  Gyroscope)
    }

    //////////////

    @Entity
    data class Barometer(
        @PrimaryKey(autoGenerate = true) val id:Int,
        @ColumnInfo(name = "timestamp" ) val timestamp: Long,
        @ColumnInfo(name = "session_id") val sessionId: Long,
        @ColumnInfo(name = "data") val data: String,
        @ColumnInfo(name= "label") val label:String,
        @ColumnInfo(name = "is_synced") val isSynced: Boolean
    )

    @Dao
    interface BarometerDao{
        @Query("SELECT * FROM barometer")
        fun getAll(): List< Barometer>

        @Query("SELECT * FROM barometer WHERE session_id IN (:sessionIds)")
        fun loadAllByIds(sessionIds: IntArray): List< Barometer>

        @Query("SELECT * FROM Barometer WHERE is_synced IS 0 LIMIT :limit")
        fun getUnsynced(limit:Int): List<Barometer>

        @Query("SELECT * FROM Barometer WHERE is_synced IS 0")
        fun getUnsyncedAll(): List<Barometer>

        @Query("SELECT count(*) FROM barometer WHERE is_synced IS 0")
        fun countUnsynced():Int

        @Query("UPDATE barometer SET is_synced = :status where id=:id")
        fun updateSyncStatus(id: Int, status:Boolean)

        @Update
        fun updateAll(vararg barometer: Barometer)

        @Insert
        fun insertAll(vararg barometer: Barometer)

        @Delete
        fun delete(barometer: Barometer)
    }

    //////////////

    @Entity
    data class ActivityRecognition(
        @PrimaryKey(autoGenerate = true) val id:Int,
        @ColumnInfo(name = "timestamp" ) val timestamp: Long,
        @ColumnInfo(name = "activities") val activities: String,
        @ColumnInfo(name = "activity_name") val activityName:String,
        @ColumnInfo(name = "activity_type") val activityType:Int,
        @ColumnInfo(name = "stationary") var stationary:Int = 0,
        @ColumnInfo(name = "walking") var walking:Int = 0,
        @ColumnInfo(name = "running") var running:Int = 0,
        @ColumnInfo(name = "automotive") var automotive:Int = 0,
        @ColumnInfo(name = "cycling") var cycling:Int = 0,
        @ColumnInfo(name = "unknown") var unknown:Int = 0,
        @ColumnInfo(name = "confidence") val confidence:Int,
        @ColumnInfo(name = "is_synced") val isSynced: Boolean = false
    )

    @Dao
    interface ActivityRecognitionDao{
        @Query("SELECT * FROM activityrecognition")
        fun getAll(): List<ActivityRecognition>

        @Query("SELECT * FROM activityrecognition ORDER BY id DESC limit 1")
        fun getLast(): ActivityRecognition

        @Query("SELECT * FROM activityrecognition WHERE is_synced IS 0 LIMIT :limit")
        fun getUnsynced(limit:Int): List<ActivityRecognition>

        @Query("SELECT * FROM activityrecognition WHERE is_synced IS 0")
        fun getUnsyncedAll(): List<ActivityRecognition>

        @Query("SELECT count(*) FROM activityrecognition WHERE is_synced IS 0")
        fun countUnsynced():Int

        @Update
        fun updateAll(vararg activityrecognition: ActivityRecognition)

        @Query("UPDATE activityrecognition SET is_synced = :status where id=:id")
        fun updateSyncStatus(id: Int, status:Boolean)

        @Insert
        fun insertAll(vararg activityrecognition: ActivityRecognition)

        @Insert
        fun insert(activityrecognition: ActivityRecognition)

        @Delete
        fun delete(activityrecognition: ActivityRecognition)
    }


    //////////////

    @Entity
    data class Pedometer(
        @PrimaryKey(autoGenerate = true) val id:Int,
        @ColumnInfo(name = "timestamp" ) val startTimestamp: Long,
        @ColumnInfo(name = "end_timestamp" ) val endTimestamp: Long,
        @ColumnInfo(name = "steps") val steps: Int,
        @ColumnInfo(name = "total_steps") val totalSteps:Int,
        @ColumnInfo(name = "is_synced") val isSynced: Boolean
    )

    @Dao
    interface PedometerDao{
        @Query("SELECT * FROM pedometer")
        fun getAll(): List<Pedometer>

        @Query("SELECT * FROM pedometer ORDER BY id DESC limit 1")
        fun getLast(): Pedometer?

        @Query("SELECT SUM(steps) FROM pedometer WHERE timestamp BETWEEN :start AND :end")
        fun getTotalSteps(start:Long, end:Long): Int

        @Query("SELECT * FROM pedometer WHERE is_synced IS 0 LIMIT :limit")
        fun getUnsynced(limit:Int): List<Pedometer>

        @Query("SELECT * FROM pedometer WHERE is_synced IS 0")
        fun getUnsyncedAll(): List<Pedometer>

        @Query("SELECT count(*) FROM pedometer WHERE is_synced IS 0")
        fun countUnsynced():Int

        @Query("UPDATE pedometer SET is_synced = :status where id=:id")
        fun updateSyncStatus(id: Int, status:Boolean)

        @Update
        fun updateAll(vararg pedometer: Pedometer)

        @Insert
        fun insert(pedometer: Pedometer)

        @Insert
        fun insertAll(vararg pedometer: Pedometer)

        @Delete
        fun delete(pedometer: Pedometer)
    }

    //////////////
    @Database(entities = [Location::class, LinearAccelerometer::class,
                            Gyroscope::class, Barometer::class,
                            ActivityRecognition::class, Pedometer::class], version = 1)
    abstract class AppDatabase : RoomDatabase() {
        abstract fun locationDao(): LocationDao
        abstract fun linearAccelerometerDao(): LinearAccelerometerDao
        abstract fun gyroscopeDao(): GyroscopeDao
        abstract fun barometerDao(): BarometerDao
        abstract fun activityRecognitionDao(): ActivityRecognitionDao
        abstract fun pedometerDao(): PedometerDao
        companion object {
            // Singleton prevents multiple instances of database opening at the
            // same time.
            @Volatile
            private var INSTANCE: AppDatabase? = null

            fun getDatabase(context: Context):AppDatabase {
                val tempInstance = INSTANCE
                if (tempInstance != null) {
                    return tempInstance
                }
                synchronized(this) {
                    val instance = Room.databaseBuilder(
                        context.applicationContext,
                        AppDatabase::class.java,
                        "app_database"
                    ).enableMultiInstanceInvalidation().build()
                    INSTANCE = instance
                    return instance
                }
            }
        }
    }

}