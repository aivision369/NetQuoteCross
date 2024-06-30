import 'dart:math';

import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Helper {
  static String getHumanReadable(int bytes) {
    int kilobyte = 1024;
    int megabyte = kilobyte * 1024;
    int gigabyte = megabyte * 1024;
    int terabyte = gigabyte * 1024;

    String output = "0 MB";
    if (bytes >= 0 && bytes <= kilobyte) {
      output = "${truncateToDecimalPlaces(bytes, 2)} B";
    } else if (bytes >= kilobyte && bytes < megabyte) {
      output = "${truncateToDecimalPlaces((bytes / kilobyte), 2).toString()} KB";
    } else if (bytes > megabyte && bytes < gigabyte) {
      output = "${truncateToDecimalPlaces((bytes / megabyte), 2).toString()} MB";
    } else if (bytes > gigabyte && bytes < terabyte) {
      output = "${truncateToDecimalPlaces((bytes / gigabyte), 2).toString()} GB";
    } else if (bytes >= terabyte) {
      output = "${truncateToDecimalPlaces((bytes / terabyte), 2).toString()} TB";
    }
    return output;
  }

  static double truncateToDecimalPlaces(num value, int fractionalDigits) =>
      (value * pow(10, fractionalDigits)).truncate() /
      pow(10, fractionalDigits);

  static String getTime() {
    final dateFormat = DateFormat("HH:mm");
    String time = dateFormat.format(DateTime.now());
    return time;
  }

  static String getDay() {
    final dateFormat = DateFormat("EEEE, dd MMMM, yyyy");
    String time = dateFormat.format(DateTime.now());
    return time;
  }

  static int platformSpecificLogic(){
    if(kIsWeb){
      // The app is running on the web
      print("Running on the web");
    } else if (Platform.isAndroid) {
      // The app is running on Android
      print("Running on Android");
    } else if (Platform.isIOS) {
      // The app is running on iOS
      print("Running on iOS");
    } else if (Platform.isWindows) {
      // The app is running on Windows
      print("Running on Windows");
    } else if (Platform.isMacOS) {
      // The app is running on macOS
      print("Running on macOS");
    } else if (Platform.isLinux) {
      // The app is running on Linux
      print("Running on Linux");
    } else {
      // The app is running on an unknown platform
      print("Running on an unknown platform");
    }
    return 0;
  }
}
