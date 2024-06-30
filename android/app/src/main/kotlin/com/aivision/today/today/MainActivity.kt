package com.aivision.today.today

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.aivision.today.today/dataUsage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            println("request received from flutter......")
            if (call.method == "getDailyDataUsage") {
                println("method if condition is true......")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    val usageStatsService = UsageStatsService(this)
                    if (usageStatsService.checkUsageStatsPermission()) {
                        val dataUsage = usageStatsService.getTotalDailyDataUsage()
                        println("Data : data is received and ready to convert into human readable form")
                        result.success(dataUsage)

                        if (dataUsage > 1) {
                            println("Data : ${Convertor.bytesIntoHumanReadable(dataUsage)}")
                            //result.success(Convertor.bytesIntoHumanReadable(dataUsage))
                        } else {
                            result.success("0 M")
                            println("Data : 0")
                        }
                        //result.success(dataUsage)
                    } else {
                        result.error(
                            "PERMISSION_DENIED",
                            "Usage stats permission not granted",
                            null
                        )
                    }
                } else {
                    result.error("UNAVAILABLE", "Android version is below Marshmallow", null)
                }
            } else {
                println("method else condition is executed......")
                result.notImplemented()
            }
        }
    }
}
