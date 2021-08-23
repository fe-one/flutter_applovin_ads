import 'dart:async';

import 'package:flutter/services.dart';

typedef ApplovinAdsHandler = Function(String adUnitId);
typedef ApplovinAdsHandlerError = Function(String adUnitId, String error);

class FlutterApplovinAds {
  static const MethodChannel _channel = MethodChannel('flutter_applovin_ads');

  static Future initialize({String? privacyPolicyURL, String? termsOfServiceURL}) async {
    await _channel.invokeMethod('initialize', {
      "privacyPolicyURL": privacyPolicyURL,
      "termsOfServiceURL": termsOfServiceURL,
    });
  }

  static Future<bool?> createInterstitialAd(
    String adUnitIdentifier, {
    ApplovinAdsHandler? didLoad,
    ApplovinAdsHandlerError? didFailToLoadAd,
    ApplovinAdsHandler? didDisplay,
    ApplovinAdsHandler? didClick,
    ApplovinAdsHandler? didHide,
    ApplovinAdsHandlerError? didFail,
  }) async {
    final res = await _channel.invokeMethod('createInterstitialAd', {
      "adUnitIdentifier": adUnitIdentifier,
    });
    _channel.setMethodCallHandler((call) {
      var arguments = call.arguments;
      switch (call.method) {
        case "didLoad":
          if (didLoad != null) didLoad(call.arguments["adUnitId"] as String);
          break;
        case "didFailToLoadAd":
          if (didFailToLoadAd != null) didFailToLoadAd(arguments["adUnitId"] as String, arguments["error"] as String);
          break;
        case "didDisplay":
          if (didDisplay != null) didDisplay(call.arguments["adUnitId"] as String);
          break;
        case "didClick":
          if (didClick != null) didClick(call.arguments["adUnitId"] as String);
          break;
        case "didHide":
          if (didHide != null) didHide(call.arguments["adUnitId"] as String);
          break;
        case "didFail":
          if (didFail != null) didFail(call.arguments["adUnitId"] as String, arguments["error"] as String);
          break;
        default:
          break;
      }
      return Future.value(true);
    });
    return Future.value(res as bool);
  }

  static Future<bool?> showInterstitialAd() async {
    final res = await _channel.invokeMethod('showInterstitialAd');
    return Future.value(res as bool);
  }
}
