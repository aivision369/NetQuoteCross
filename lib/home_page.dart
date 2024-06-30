import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:today/quote_card.dart';

import 'helper.dart';
import 'my_globals.dart' as globals;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel(globals.globalMethodChannel);
  static const platformIOS = MethodChannel(globals.globalMethodChannelIOS);
  String _dataUsage = "0 MB";
  String quotes = "";

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      // Check if the app is running on Android
      if (Platform.isAndroid) {
        _getDailyDataUsage("Android");
      } else if (Platform.isIOS) {
        _getDailyDataUsage("iOS");
      }
    }
  }

  Future<void> _getDailyDataUsage(String _platform) async {
    String dataUsage = "0 MB";
    try {
      if (_platform == "Android") {
        final int result = await platform.invokeMethod('getDailyDataUsage');
        dataUsage = Helper.getHumanReadable(result);
      } else if (_platform == "iOS") {
        final int result = await platformIOS.invokeMethod('getDailyDataUsage');
        //dataUsage = Helper.getHumanReadable(result);
      }
    } on PlatformException catch (e) {
      print("Exception occur....... :${e.message}");
    }

    setState(() {
      _dataUsage = dataUsage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width * 0.80;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
            Center(
              child: Text(
                Helper.getTime(),
                style: const TextStyle(
                    fontSize: 85,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                Helper.getDay(),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Container(
                width: _width,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.5), Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 10.0,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: const Offset(-4.0, -4.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          _dataUsage,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          globals.globalStrTodayUse,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const QuoteCard(),
          ],
        ),
      ),
    );
  }
}
