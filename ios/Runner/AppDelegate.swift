import Flutter
import UIKit
import CoreLocation
import NaturalLanguage
import MapKit


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // MapKitView를 등록
        let registrar = self.registrar(forPlugin: "MapKitViewPlugin")
        registrar?.register(MapKitViewFactory(), withId: "MapKitView")
        
        // MethodChannel, EventChannel 및 MessageChannel을 초기화
        BinaryMessageHandler.register(binaryMessenger: controller.binaryMessenger)
        MessageChannels.register(controller: controller)
        MethodChannels.register(controller: controller)
        EventChannels.register(controller: controller)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        LocationManager.shared.stopUpdatingLocation()
        print("앱이 종료됩니다. 리소스를 정리합니다.")
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        LocationManager.shared.stopUpdatingLocation()
        print("앱이 백그라운드로 전환되었습니다.")
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        LocationManager.shared.startUpdatingLocation()
        print("앱이 포그라운드로 돌아왔습니다. 위치 업데이트를 다시 시작합니다.")
    }
}
