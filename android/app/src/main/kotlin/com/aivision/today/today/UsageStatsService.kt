package com.aivision.today.today


import android.annotation.TargetApi
import android.app.usage.NetworkStats
import android.app.usage.NetworkStatsManager
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.os.Build
import android.os.RemoteException

import java.util.Calendar

@TargetApi(Build.VERSION_CODES.KITKAT)
class UsageStatsService(private val context: Context) {


    //@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    fun checkUsageStatsPermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val mode = appOps.checkOpNoThrow(android.app.AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName)
        return if (mode == android.app.AppOpsManager.MODE_ALLOWED) {
            true
        } else {
            val action = android.provider.Settings.ACTION_USAGE_ACCESS_SETTINGS
            val intent = Intent(action)
            context.startActivity(intent)
            false
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    //@RequiresApi(Build.VERSION_CODES.M)
    private fun getDataUsageForNetworkType(networkType: Int, subscriberId: String?): Long {
        val networkStatsManager = context.getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager

        // Set time to the start of the day
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()

        return try {
            val bucket = networkStatsManager.querySummaryForDevice(networkType, subscriberId, startTime, endTime)
            bucket.rxBytes + bucket.txBytes
        } catch (e: RemoteException) {
            e.printStackTrace()
            0
        } catch (e: SecurityException) {
            e.printStackTrace()
            0
        }
    }

    //@RequiresApi(Build.VERSION_CODES.M)
    fun getTotalDailyDataUsage(): Long {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as android.telephony.TelephonyManager
        val subscriberId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            null
        } else {
            telephonyManager.subscriberId
        }

        val mobileDataUsage = getDataUsageForNetworkType(ConnectivityManager.TYPE_MOBILE, subscriberId)
        val wifiDataUsage = getDataUsageForNetworkType(ConnectivityManager.TYPE_WIFI, null)

        return mobileDataUsage + wifiDataUsage
    }
}