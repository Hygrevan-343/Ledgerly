package com.example.ui

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings
import android.net.Uri
import io.flutter.embedding.engine.FlutterEngineCache
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "floating_widget_channel"
    private val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate called")
        handleWidgetIntent(intent)
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent called")
        setIntent(intent) // Important: update the intent
        handleWidgetIntent(intent)
    }
    
    private fun handleWidgetIntent(intent: Intent?) {
        Log.d(TAG, "handleWidgetIntent called with intent: ${intent?.toString()}")
        
        var widgetAction: String? = null
        
        // Check for widget action in extras first
        if (intent?.hasExtra("widget_action") == true) {
            widgetAction = intent.getStringExtra("widget_action")
            Log.d(TAG, "Found widget_action in extras: $widgetAction")
        }
        
        // Also check URI data as fallback
        intent?.data?.let { uri ->
            Log.d(TAG, "Intent data URI: $uri")
            if (uri.scheme == "raseedwidget") {
                val actionFromUri = uri.host
                if (actionFromUri != null) {
                    widgetAction = actionFromUri
                    Log.d(TAG, "Found widget_action in URI: $widgetAction")
                }
            }
        }
        
        // Save the action for Flutter to pick up
        if (widgetAction != null && widgetAction.isNotEmpty()) {
            val prefs = getSharedPreferences("HomeWidgetPreferences", MODE_PRIVATE)
            val success = prefs.edit()
                .putString("widget_action", widgetAction)
                .putLong("widget_action_time", System.currentTimeMillis())
                .commit()
            
            Log.d(TAG, "Widget action saved: $widgetAction at ${System.currentTimeMillis()}, success: $success")
        } else {
            Log.d(TAG, "No widget action found in intent")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Cache the engine so the service can access it
        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "startFloatingWidget" -> {
                    val intent = Intent(this, FloatingWidgetService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "requestOverlayPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
                        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
                        startActivity(intent)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
