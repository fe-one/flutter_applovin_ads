import Flutter
import UIKit
import AppLovinSDK

var globalChannel: FlutterMethodChannel?
public class SwiftFlutterApplovinAdsPlugin: NSObject, FlutterPlugin, MAAdDelegate  {
    var interstitialAd: MAInterstitialAd!
    var isInit: Bool = false
    public static func register(with registrar: FlutterPluginRegistrar) {
        globalChannel = FlutterMethodChannel(name: "flutter_applovin_ads", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterApplovinAdsPlugin()
        registrar.addMethodCallDelegate(instance, channel: globalChannel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if !self.isInit && call.method != "initialize" {
            result(false)
            return
        }
        switch(call.method) {
        case "initialize":
            initialize(call, result)
        case "createInterstitialAd":
            createInterstitialAd(call)
            result(true)
        case "showInterstitialAd":
            showInterstitialAd()
            result(true)
        default:
            result(false)
        }
    }
    
    private func initialize(_ call: FlutterMethodCall,_ result: FlutterResult) {
        var sdk: ALSdk
        // 自带同意流程 针对14.5 暂且用不到
        //       let params = call.arguments as? NSDictionary
        //       let privacyPolicyURL = params!["privacyPolicyURL"] as! String
        //       let termsOfServiceURL = params!["termsOfServiceURL"] as? String
        //       let settings = ALSdkSettings()
        //       settings.consentFlowSettings.isEnabled = true
        //       settings.consentFlowSettings.privacyPolicyURL = URL(string: privacyPolicyURL)
        //
        //       // Terms of Service URL is optional
        //       if termsOfServiceURL != nil {
        //         settings.consentFlowSettings.termsOfServiceURL = URL(string: termsOfServiceURL!)
        //       }
        //
        //        sdk = ALSdk.shared(with: settings)!
        sdk = ALSdk.shared()!
        sdk.mediationProvider = "max"
        sdk.initializeSdk { (configuration: ALSdkConfiguration) in
            print(" sdk success")
            self.isInit = true
        }
        result(nil)
    }
    
    private func createInterstitialAd(_ call: FlutterMethodCall) {
        let params = call.arguments as? NSDictionary
        let adUnitIdentifier = params!["adUnitIdentifier"] as! String
        interstitialAd = MAInterstitialAd(adUnitIdentifier: adUnitIdentifier)
        interstitialAd.delegate = self
        interstitialAd.load()
        print("ads load \(adUnitIdentifier)")
    }
    
    private func showInterstitialAd() {
        if interstitialAd != nil && interstitialAd.isReady {
            interstitialAd.show()
            print("ads show")
        }
    }
    
    public func didLoad(_ ad: MAAd) {
        print("ads loaded")
        let params: Dictionary<String, String> = ["adUnitId": ad.adUnitIdentifier]
        globalChannel!.invokeMethod("didLoad", arguments: params)
    }
    
    public func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError)
    {
        print("ads didFailToLoadAd \(error.message) \(error.adLoadFailureInfo)")
        let params: Dictionary<String, String> = ["adUnitId": adUnitIdentifier, "error": error.message]
        globalChannel!.invokeMethod("didFailToLoadAd", arguments: params)
    }
    
    public func didDisplay(_ ad: MAAd) {
        let params: Dictionary<String, String> =  ["adUnitId": ad.adUnitIdentifier]
        globalChannel!.invokeMethod("didDisplay", arguments: params)
    }
    
    public func didClick(_ ad: MAAd) {
        let params: Dictionary<String, String> =  ["adUnitId": ad.adUnitIdentifier]
        globalChannel!.invokeMethod("didClick", arguments: params)
    }
    
    public func didHide(_ ad: MAAd) {
        let params: Dictionary<String, String> =  ["adUnitId": ad.adUnitIdentifier]
        globalChannel!.invokeMethod("didHide", arguments: params)
    }
    
    public func didFail(toDisplay ad: MAAd, withError error: MAError) {
        let params: Dictionary<String, String> = ["adUnitId": ad.adUnitIdentifier, "error": error.message]
        globalChannel!.invokeMethod("didFail", arguments: params)
    }
    
}
