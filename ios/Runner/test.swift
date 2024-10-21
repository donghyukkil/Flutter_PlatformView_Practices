class MapKitViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return MapKitView(frame: frame) // MapKitView를 생성하여 반환
    }
}

class MapKitView: NSObject, FlutterPlatformView, MKMapViewDelegate {
    private var mapView: MKMapView
    
    init(frame: CGRect) {
        mapView = MKMapView(frame: frame) // MKMapView를 초기화
        super.init()
        mapView.showsUserLocation = true // 사용자의 위치를 지도에 표시
        mapView.mapType = .standard // 지도 타입을 기본 지도 형식으로 설정
        mapView.delegate = self // MKMapViewDelegate 설정
    }
    
    func setRegion(centerCoordinate: CLLocationCoordinate2D, radiusInMeters: Double) {
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: radiusInMeters, longitudinalMeters: radiusInMeters)
        mapView.setRegion(region, animated: true) // 지정된 좌표와 반경으로 지도를 설정
    }
    
    func view() -> UIView {
        return mapView // Flutter에서 사용할 수 있도록 UIView 반환
    }
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // 'MapKitView'라는 viewType을 등록
        if let registrar = controller.registrar(forPlugin: "MapKitViewPlugin") {
            registrar.register(MapKitViewFactory(), withId: "MapKitView")
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
