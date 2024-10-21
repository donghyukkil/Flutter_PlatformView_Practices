import Flutter
import UIKit
import CoreLocation
import NaturalLanguage
import MapKit

class MapKitViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return MapKitView(frame: frame)
    }
}

class MapKitView: NSObject, FlutterPlatformView, MKMapViewDelegate {
    private var mapView: MKMapView
    private var locationEventSink: FlutterEventSink?
    
    init(frame: CGRect) {
        mapView = MKMapView(frame: frame)
        super.init()
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.delegate = self
    }
    
    func setRegion(centerCoordinate: CLLocationCoordinate2D, radiusInMeters: Double) {
        let zoomRadius: Double = 1000
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: zoomRadius, longitudinalMeters: zoomRadius)
        mapView.setRegion(region, animated: false)
    }
    
    func view() -> UIView {
        return mapView
    }
    
    func setEventSink(_ eventSink: FlutterEventSink?) {
        self.locationEventSink = eventSink
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let eventSink = locationEventSink else {
            print("Event sink is nil")
            return
        }
        
        guard let location = userLocation.location else {
            print("Location data is not available")
            return
        }
        

        setRegion(centerCoordinate: location.coordinate, radiusInMeters: 100)
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "course": location.course
        ]
        
        eventSink(locationData)
        print("Location data sent: \(locationData)")
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler, CLLocationManagerDelegate {
    private var locationEventSink: FlutterEventSink?
    var mapKitView: MapKitView?
    
    let locationManager = CLLocationManager()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // MapKitView를 등록
        if let registrar = controller.registrar(forPlugin: "MapKitViewPlugin") {
            registrar.register(MapKitViewFactory(), withId: "MapKitView")
        } else {
            print("Failed to get the registrar for MapKitViewPlugin")
        }
            
        let platformChannel = FlutterMethodChannel(name: "samples.flutter.dev/device", binaryMessenger: controller.binaryMessenger)
                
        platformChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            switch call.method {
            case "getBatteryData":
                self?.receiveBatteryLevel(result: result)
                
            case "getDeviceInfo":
                self?.receiveDeviceInfo(result: result)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        let locationChannel = FlutterEventChannel(name:  "samples.flutter.dev/location" , binaryMessenger: controller.binaryMessenger)
        locationChannel.setStreamHandler(self)
        
        let messageChannel = FlutterBasicMessageChannel(name: "samples.flutter.dev/chat", binaryMessenger: controller.binaryMessenger, codec: FlutterStringCodec.sharedInstance())
        
        messageChannel.setMessageHandler { (message: Any?, reply: FlutterReply) in
            if let text = message as? String {
                let textLength = text.count
                reply("\(textLength)")
            } else {
                reply("0")
            }
            
        }
        
        let binaryMessenger = controller.binaryMessenger
        
        binaryMessenger.setMessageHandlerOnChannel("samples.flutter.dev/binary") { (message: Data?, reply: FlutterBinaryReply) in
            if let data = message {
                // 데이터가 2바이트 단위로 전달해서 데이터 길이 연산을 가정하여 결과 산출
                let length = data.count / 2
                var response = withUnsafeBytes(of: Int32(length).bigEndian) {Data($0)}
                reply(response)
            } else {
                reply(nil)
            }
        }
        
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        if let channelName = arguments as? String {
            switch channelName {
            case "location":
                self.locationEventSink = eventSink
                mapKitView?.setEventSink(eventSink)
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
            default:
                return FlutterError(code: "UNAVAILABLE", message: "UnKnown channel", details: nil)
            }
        }
        return nil
        
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if let channelName = arguments as? String {
            switch channelName {
            case "location":
                locationManager.stopUpdatingLocation()
                mapKitView?.setEventSink(nil)
                self.locationEventSink = nil
            default:
                return FlutterError(code: "UNAVAILABLE", message: "UnKnown channel", details: nil)
            }
        }
        
        return nil
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        
        device.isBatteryMonitoringEnabled = true
        
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(
                code: "Unavailable", message: "Battery level not available", details: nil)
            )
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
    
    private func receiveDeviceInfo(result: FlutterResult) {
        let device = UIDevice.current
        
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            
            let totalSpace = attributes[.systemSize] as? Int64 ?? 0
            let freeSpace = attributes[.systemFreeSize] as? Int64 ?? 0
            
            let totalSpaceGB = Double(totalSpace) / (1024 * 1024 * 1024)
            let freeSpaceGB = Double(freeSpace) / (1024 * 1024 * 1024)
            
            let deviceInfo: [String: Any] = [
                "model": device.model,
                "name": device.name,
                "systemName": device.systemName,
                "systemVersion": device.systemVersion,
                "totalDiskSpaceGB": String(format: "%.2f", totalSpaceGB),
                "freeDiskSpaceGB": String(format: "%.2f", freeSpaceGB)
            ]
            
            result(deviceInfo)
        } catch {
            print("Error retrieving disk space info: \(error.localizedDescription)")
            
            let deviceInfo: [String: Any] = [
                "model": device.model,
                "name": device.name,
                "systemName": device.systemName,
                "systemVersion": device.systemVersion,
                "totalDiskSpaceGB": "Unavailable",
                "freeDiskSpaceGB": "Unavailable",
            ]
            
            result(deviceInfo)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let eventSink = locationEventSink, let location = locations.last else {
            print("Event sink or location is nil")
            return
        }
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "course": location.course
        ]
        eventSink(locationData)
        print("Location data sent: \(locationData)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            locationEventSink?(FlutterError(code: "PERMISSION_DENIED", message: "Location permissions are denied", details: nil))
        }
    }
}
