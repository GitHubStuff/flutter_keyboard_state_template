package com.icodeforyou.flutter_keyboard_template

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.icodeforyou.keyboarder/keyboard"
    private val METHOD = "getKeyboardState"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == METHOD) {
                val state: String = if (isKeyboardClosed()) "closed" else "open"
                result.success(state)
            } else {
                result.notImplemented()
            }
        }
    }
}
