package com.example.e2ee_device_binding_demo_flutter

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import android.content.Intent
import android.os.Bundle

class MainActivity: FlutterFragmentActivity() {
    companion object {
        var launchUri: Uri? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Capture the launch intent URI
        intent?.data?.let {
            launchUri = it
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,"app.linking.channel").setMethodCallHandler { call, result -> if (call.method == "getLaunchUri") {
                result.success(launchUri?.toString())
                // Optional: clear it after first head
                launchUri = null
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Handle new intent when app is already running
        intent.data?.let {
            launchUri = it
        }
    }
}
