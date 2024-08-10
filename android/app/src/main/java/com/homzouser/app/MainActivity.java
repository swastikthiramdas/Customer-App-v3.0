//package com.astrowaydiploy.user;
//
//import io.flutter.embedding.android.FlutterFragmentActivity;
//import com.otpless.otplessflutter.OtplessFlutterPlugin;
//import android.content.Intent;
//
//public class MainActivity extends FlutterFragmentActivity {
//    override fun onNewIntent(intent: Intent) {
//        super.onNewIntent(intent)
//        val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
//        if (plugin is OtplessFlutterPlugin) {
//            plugin.onNewIntent(intent)
//        }
//    }
//
//    override fun onBackPressed() {
//        val plugin = flutterEngine?.plugins?.get(OtplessFlutterPlugin::class.java)
//        if (plugin is OtplessFlutterPlugin) {
//            if (plugin.onBackPressed()) return
//        }
//// handle other cases
//        super.onBackPressed()
//    }
//
//
//}
//
