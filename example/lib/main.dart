import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_applovin_ads/flutter_applovin_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterApplovinAds.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      _createApplovinAds();
    });
  }

  void _createApplovinAds() {
    FlutterApplovinAds.createInterstitialAd("3903019ddxxxxxx", didLoad: (adUnitId) {
      print("ad_load");
      // FlutterApplovinAds.showInterstitialAd();
    }, didFailToLoadAd: (adUnitId, error) {
      print("ad_load_fail");
    }, didDisplay: (adUnitId) {
      print("ad_show");
    }, didHide: (adUnitId) {
      print("ad_close");
    }, didFail: (adUnitId, error) {
      print("ad_show_fail");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: TextButton(
              onPressed: () {
                FlutterApplovinAds.showInterstitialAd();
              },
              child: Text('click'))),
    );
  }
}
