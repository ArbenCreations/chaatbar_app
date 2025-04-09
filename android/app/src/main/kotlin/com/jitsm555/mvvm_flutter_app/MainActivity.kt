package com.thechaatbar

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    /* private val CHANNEL = "com.thechaatbarCustomer/clover"

     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
         super.configureFlutterEngine(flutterEngine)
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
             if (call.method == "startTransaction") {
                 startTransaction()
                 result.success(null)
             } else {
                 result.notImplemented()
             }
         }
     }

     private fun startTransaction() {
         val account = CloverAccount.getAccount(applicationContext)
         if (account != null) {
             val intent = Intent(Intents.ACTION_PURCHASE)
             intent.putExtra(Intents.EXTRA_AMOUNT, 1000L) // Set the amount in cents
             intent.putExtra(Intents.EXTRA_ORDER_ID, "5131FEFE5121") // Set a unique order ID
             startActivityForResult(intent, REQUEST_CODE)
         } else {
             // Handle no account found scenario
         }
     }*/
}
