package com.example.teest.apptest

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "secureShotChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "secureShotChannel") {
                window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                result.success("Native activity launched")
            } else {
                result.notImplemented()
            }
        }
    }
}

