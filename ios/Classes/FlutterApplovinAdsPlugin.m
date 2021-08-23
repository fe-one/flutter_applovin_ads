#import "FlutterApplovinAdsPlugin.h"
#if __has_include(<flutter_applovin_ads/flutter_applovin_ads-Swift.h>)
#import <flutter_applovin_ads/flutter_applovin_ads-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_applovin_ads-Swift.h"
#endif

@implementation FlutterApplovinAdsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterApplovinAdsPlugin registerWithRegistrar:registrar];
}
@end
