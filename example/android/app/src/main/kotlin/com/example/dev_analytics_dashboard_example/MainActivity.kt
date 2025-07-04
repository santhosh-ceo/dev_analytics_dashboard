package com.example.dev_analytics_dashboard

import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.FileReader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/cpu_usage"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getCpuUsage") {
                val cpuUsage = getCpuUsage()
                result.success(cpuUsage)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getCpuUsage(): Double {
        try {
            val reader = BufferedReader(FileReader("/proc/stat"))
            val cpuLine = reader.readLine()
            reader.close()

            val stats = cpuLine.split("\\s+".toRegex()).drop(1).map { it.toLong() }
            val idle = stats[3]
            val total = stats.sum()

            Thread.sleep(100)

            val reader2 = BufferedReader(FileReader("/proc/stat"))
            val cpuLine2 = reader2.readLine()
            reader2.close()

            val stats2 = cpuLine2.split("\\s+".toRegex()).drop(1).map { it.toLong() }
            val idle2 = stats2[3]
            val total2 = stats2.sum()

            val usage = (1.0 - (idle2 - idle).toDouble() / (total2 - total)) * 100
            return usage
        } catch (e: Exception) {
            return 0.0
        }
    }
}