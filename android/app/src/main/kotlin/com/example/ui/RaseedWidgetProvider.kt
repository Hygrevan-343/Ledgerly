package com.example.ui

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class RaseedWidgetProvider : AppWidgetProvider() {

    companion object {
        // Unique request codes for each button to prevent conflicts
        private const val CAMERA_REQUEST_CODE = 1001
        private const val GALLERY_REQUEST_CODE = 1002
        private const val ASSIST_REQUEST_CODE = 1003
        private const val MAIN_REQUEST_CODE = 1004
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Update all widgets
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        // Get shared preferences data
        val widgetData = HomeWidgetPlugin.getData(context)
        
        // Create RemoteViews object
        val views = RemoteViews(context.packageName, R.layout.raseed_widget)
        
        // Update text views with data from Flutter
        val recentBillTitle = widgetData.getString("recent_bill", "No recent bills")
        val recentBillAmount = widgetData.getString("recent_bill_amount", "₹0.00")
        val recentBillMerchant = widgetData.getString("recent_bill_merchant", "")
        
        views.setTextViewText(R.id.recent_bill_title, recentBillTitle)
        views.setTextViewText(R.id.recent_bill_amount, recentBillAmount)
        views.setTextViewText(R.id.recent_bill_merchant, recentBillMerchant)
        
        // Set up individual button click intents with unique request codes
        setupCameraButton(context, views)
        setupGalleryButton(context, views)
        setupAssistButton(context, views)
        setupMainAreaClick(context, views)
        
        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
    
    private fun setupCameraButton(context: Context, views: RemoteViews) {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            putExtra("widget_action", "camera")
            data = Uri.parse("raseedwidget://camera?t=${System.currentTimeMillis()}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        
        val pendingIntent = PendingIntent.getActivity(
            context,
            CAMERA_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        views.setOnClickPendingIntent(R.id.camera_button, pendingIntent)
    }
    
    private fun setupGalleryButton(context: Context, views: RemoteViews) {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            putExtra("widget_action", "gallery")
            data = Uri.parse("raseedwidget://gallery?t=${System.currentTimeMillis()}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        
        val pendingIntent = PendingIntent.getActivity(
            context,
            GALLERY_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        views.setOnClickPendingIntent(R.id.gallery_button, pendingIntent)
    }
    
    private fun setupAssistButton(context: Context, views: RemoteViews) {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            putExtra("widget_action", "assist")
            data = Uri.parse("raseedwidget://assist?t=${System.currentTimeMillis()}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        
        val pendingIntent = PendingIntent.getActivity(
            context,
            ASSIST_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        views.setOnClickPendingIntent(R.id.assist_button, pendingIntent)
    }
    
    private fun setupMainAreaClick(context: Context, views: RemoteViews) {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_MAIN
            addCategory(Intent.CATEGORY_LAUNCHER)
            putExtra("widget_action", "main")
            data = Uri.parse("raseedwidget://main?t=${System.currentTimeMillis()}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        
        val pendingIntent = PendingIntent.getActivity(
            context,
            MAIN_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Set click listener only for the recent bill container
        views.setOnClickPendingIntent(R.id.recent_bill_container, pendingIntent)
    }
} 