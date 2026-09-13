package com.rmdeveloper.anunciaMiLlegada

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "rmdeveloper/mapbox_access_token",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAccessToken" -> result.success(readMapboxAccessToken())
                else -> result.notImplemented()
            }
        }
    }

    private fun readMapboxAccessToken(): String? {
        val resources = applicationContext.resources
        val resId = resources.getIdentifier(
            "mapbox_access_token",
            "string",
            applicationContext.packageName,
        )
        val token = if (resId != 0) {
            resources.getString(resId)
        } else {
            ""
        }
        return token.ifBlank { null }
    }
}