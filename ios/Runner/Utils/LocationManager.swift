import CoreLocation
import Flutter

class LocationManager: NSObject, CLLocationManagerDelegate, FlutterStreamHandler {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var locationEventSink: (([String: Any]) -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let location = locations.last else { return }
         
         let locationData: [String: Any] = [
             "latitude": location.coordinate.latitude,
             "longitude": location.coordinate.longitude,
             "course": location.course
         ]
         
         locationEventSink?(locationData)  // 위치 데이터를 MapKitView로 전달
     }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .denied || status == .restricted {
              locationEventSink?(["error": "Location permissions are denied"])
          }
      }
      
    
    // FlutterStreamHandler 프로토콜 메서드
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        locationEventSink = events
        startUpdatingLocation()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopUpdatingLocation()
        locationEventSink = nil
        return nil
    }
}
