
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

abstract class SecureShot {
  SecureShot._();

  static const _channel = MethodChannel('secureShotChannel');

  static void on() {
    if (Platform.isAndroid) {
      _channel.invokeMethod('secureShotChannel');
    } else if (Platform.isIOS) {
      _channel.invokeMethod("secureIOS");
    }
  }

  static void off() {
    if (Platform.isAndroid) {
      _channel.invokeMethod('secureShotChannel');
    } else if (Platform.isIOS) {
      _channel.invokeMethod("unSecureIOS");
    }
  }
}
