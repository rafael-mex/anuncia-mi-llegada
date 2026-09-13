import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "MapboxAccessTokenChannel")
    let channel = FlutterMethodChannel(
      name: "rmdeveloper/mapbox_access_token",
      binaryMessenger: registrar!.messenger()
    )
    channel.setMethodCallHandler { call, result in
      if call.method == "getAccessToken" {
        let token = Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as? String
        result((token?.isEmpty == false) ? token : nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}