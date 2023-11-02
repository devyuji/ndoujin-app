package com.example.mobileapp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.widget.Toast;
import android.os.Build;

class MainActivity: FlutterActivity() {
  private val CHANNEL = "devyuji.com/ndoujin"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "toastMessage") {
        val argument = call.arguments() as Map<String, String>?
        val toast = Toast.makeText(this, argument?.get("text")?.toString() ?: "", Toast.LENGTH_SHORT)
        toast.show()
        
        result.success("")
      } else if (call.method == "SupportedAbis") {
        val abis = Build.SUPPORTED_ABIS;

        result.success(abis[0])
      } else {
        result.notImplemented()
      }
    }
  }
}