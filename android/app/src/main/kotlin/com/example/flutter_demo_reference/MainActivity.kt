package com.example.flutter_demo_reference

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.BatteryManager
import android.os.Build
import android.provider.Settings
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.Manifest
import java.security.Permission
import java.security.Permissions


//import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity(){
    private val FLUTTERCHANNEL = "flutter-channel";
    private  val GET_BATTERY_LEVEL = "getBatteryLevel";
    private val OPEN_SETTING = "openSetting";
    private val REQUEST_LOCATION_PERMISSION = "requestLocationPermission";

    private val CHECK_LOCATION_PERMISSION = "checkLocationPermission";
    private val LOCATION_PERMISSION_REQUEST_CODE = 100

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

        return batteryLevel
    }

    private fun openSetting() {
        return startActivity(Intent(Settings.ACTION_SETTINGS));
    }

    private fun requestLocationPermission() {
//        LocationManager reponse = getSystemService(Context.LOCATION_SERVICE);
    }

    private fun checkLocationPermission() {
        // Check if location permission is already granted
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED
        ) {
            // Request permission
            ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                    LOCATION_PERMISSION_REQUEST_CODE
            )
        } else {
            // Permission already granted
            onLocationPermissionGranted()
        }
    }
    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted
                onLocationPermissionGranted()
            } else {
                // Permission denied
                Toast.makeText(this, "Location permission denied", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun onLocationPermissionGranted() {
        Toast.makeText(this, "Location permission granted", Toast.LENGTH_SHORT).show()
        // Proceed with accessing location
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLUTTERCHANNEL).setMethodCallHandler {
            call, result ->
                when(call.method) {
                    GET_BATTERY_LEVEL ->  {
                        val batteryLevel = getBatteryLevel()
                        if (batteryLevel != -1) {
                            result.success(batteryLevel)
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available.", null)
                        }
                    }
                    OPEN_SETTING -> {
                        openSetting();
                    }
                    CHECK_LOCATION_PERMISSION -> {
                        checkLocationPermission();
                    }
                }
        }
    }
}
