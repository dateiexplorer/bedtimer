package de.dateiexplorer.apps.bedtimer

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioAttributes.CONTENT_TYPE_MUSIC
import android.media.AudioAttributes.USAGE_MEDIA
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.AudioManager.AUDIOFOCUS_GAIN
import android.os.Binder
import android.os.Build
import android.os.CountDownTimer
import android.os.IBinder
import android.os.PowerManager
import androidx.annotation.RequiresApi
import androidx.lifecycle.MutableLiveData
import de.dateiexplorer.apps.bedtimer.R
import io.flutter.Log

private const val NOTIFICATION_ID = 1
private const val NOTIFICATION_CHANNEL_ID = "de.dateiexplorer.apps.bedtimer/timer.notification"
private const val NOTIFICATION_CHANNEL_NAME = "Timer notification"

class TimerService : Service() {

    private val tag: String = TimerService::class.java.name

    override fun onBind(intent: Intent?): IBinder? = mBinder

    private val mBinder: IBinder = MyBinder()

    inner class MyBinder : Binder() {
        val service: TimerService get() = this@TimerService
    }

    val liveData: MutableLiveData<Int> = MutableLiveData()

    private var wakeLock: PowerManager.WakeLock? = null
    private var isServiceStarted = false

    private var notificationBuilder: Notification.Builder? = null

    private var timer: Counter? = null

    private lateinit var notificationManager: NotificationManager

    override fun onCreate() {
        super.onCreate()
        Log.d(tag, "The service has been created.")
    }

    override fun onDestroy() {
        Log.d(tag, "The service has been destroyed.")
        timer?.cancel()
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(tag, "onStartCommand executed with startId: $startId.")
        if (intent != null) {
            val action = intent.action;
            Log.d(tag, "Using an intent with action $action.")
            when (action) {
                Actions.START.name -> {
                    val seconds = intent.getIntExtra("SECONDS", 0)
                    if (seconds <= 0) {
                        Log.d(tag, "Counter will start with a value less than zero.")
                    }
                    startService(seconds)
                }
                Actions.STOP.name -> stopService()
                else -> throw NotImplementedError()
            }
        }

        return START_STICKY
    }

    private fun startService(seconds: Int) {
        if (isServiceStarted) return
        Log.d(tag, "Starting the foreground service.");
        isServiceStarted = true

        wakeLock = (getSystemService(Context.POWER_SERVICE) as PowerManager).run {
            newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "TimerService::lock").apply {
                acquire()
            }
        }

        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationBuilder = createNotification(seconds)
        startForeground(NOTIFICATION_ID, notificationBuilder?.build())

        timer = Counter(seconds.toLong() * 1000, 1000)
        timer?.start()
    }

    fun stopService() {
        Log.d(tag, "Stopping the foreground service.")
        try {
            wakeLock?.let {
                if (it.isHeld) {
                    it.release()
                }
            }
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
        } catch (e: Exception) {
            Log.d(tag, "Service stopped without being started: ${e.message}.")
        }
        isServiceStarted = false
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(): String {
        val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_LOW);
        notificationManager.createNotificationChannel(channel)
        return NOTIFICATION_CHANNEL_ID
    }

    private fun createNotification(timeInSeconds: Int): Notification.Builder {
        var channelId =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                createNotificationChannel()
            } else {
                // If earlier version channel ID is not used
                // https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#NotificationCompat.Builder(android.content.Context)
                ""
            }

        val pendingIntent: PendingIntent =
            Intent(this, MainActivity::class.java).let { notificationIntent ->
                PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)
            }

        return Notification.Builder(this, channelId)
            .setOngoing(true)
            .setContentTitle(formatSeconds(timeInSeconds))
            .setContentIntent(pendingIntent)
            .setSmallIcon(R.drawable.ic_notification)
            .setCategory(Notification.CATEGORY_SERVICE)
    }

    private fun formatSeconds(value: Int): String {
        val hours = value / 3600
        var seconds = value % 3600
        val minutes = seconds / 60
        seconds %= 60
        return String.format("%02d:%02d:%02d", hours, minutes, seconds)
    }

    private inner class Counter(millisInFuture: Long, countDownInterval: Long) : CountDownTimer(millisInFuture, countDownInterval) {

        override fun onTick(millisUntilFinished: Long) {
            val secondsUntilFinished = (millisUntilFinished / 1000).toInt()
            val notification = notificationBuilder?.setContentTitle(formatSeconds(secondsUntilFinished))
            notificationManager.notify(NOTIFICATION_ID, notification?.build())

            liveData.postValue(secondsUntilFinished);
        }

        override fun onFinish() {
            stopService()

            val intent = Intent(this@TimerService, MainActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            application.startActivity(intent)
        }
    }
}