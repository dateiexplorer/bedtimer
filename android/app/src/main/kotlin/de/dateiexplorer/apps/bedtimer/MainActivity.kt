package de.dateiexplorer.apps.bedtimer

import android.content.ComponentName
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ryanheise.audioservice.AudioServicePlugin
import android.content.Context
import android.content.ServiceConnection
import android.net.Uri
import android.os.IBinder
import android.provider.Settings
import androidx.lifecycle.Observer
import io.flutter.Log
import io.flutter.plugin.common.EventChannel

private const val METHOD_CHANNEL = "de.dateiexplorer.apps.bedtimer/timer.methods"
private const val EVENT_CHANNEL = "de.dateiexplorer.apps.bedtimer/timer.callback"

class MainActivity: FlutterActivity() {

    private val tag: String = MainActivity::class.java.name

    var service: TimerService? = null
    var isBound: Boolean? = null
    var sink: EventChannel.EventSink? = null

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName?, iBinder: IBinder?) {
            Log.d(tag, "serviceConnection: connected to service.")

            val binder = iBinder as TimerService.MyBinder
            service = binder.service
            isBound = true

            service?.liveData?.observe(this@MainActivity, Observer {
                sink?.success(it)
            })
        }

        override fun onServiceDisconnected(className: ComponentName?) {
            Log.d(tag, "serviceConnection: disconnected from service.")
            service = null
            isBound = false
        }
    }

    private fun bindService(): Intent {
        return Intent(this, TimerService::class.java).also {
            intent -> bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)
        }
    }

    private fun unbindService(): Intent {
        return Intent(this, TimerService::class.java).also {
            isBound = false
            unbindService(serviceConnection)
        }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return AudioServicePlugin.getFlutterEngine(context);
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
            when (call.method) {
                "startTimer" -> {
                    val timeInSeconds = call.argument("timeInSeconds") as Int?

                    val intent = bindService()
                    intent.putExtra("SECONDS", timeInSeconds)
                    intent.action = Actions.START.name
                    startForegroundService(intent)

                    result.success(null)
                }
                "stopTimer" -> {
                    if (isBound == true) {
                        Log.d(MainActivity::class.java.name, "unbindService")
                        val intent = unbindService()
                        intent.action = Actions.STOP.name
                        startService(intent)
                    }
                    result.success(null);
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(MyStreamHandler())
    }

    inner class MyStreamHandler : EventChannel.StreamHandler {

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            sink = events
        }

        override fun onCancel(arguments: Any?) {
            sink = null
        }
    }
}


