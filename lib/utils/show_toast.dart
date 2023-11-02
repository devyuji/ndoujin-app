import 'package:flutter/services.dart';

class ShowToast {
  static Future<void> show(String text) async {
    const platform = MethodChannel('devyuji.com/ndoujin');
    await platform.invokeMethod('toastMessage', {"text": text});
  }
}
