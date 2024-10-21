//
//  MapKitView.swift
//  Runner
//
//  Created by donghyukkil on 10/21/24.
//

import Flutter
import MapKit
import CoreLocation

class MapKitView: NSObject, FlutterPlatformView, MKMapViewDelegate, CLLocationManagerDelegate {
    private var mapView: MKMapView
    private var locationEventSink: FlutterEventSink?
    private let locationManager = LocationManager.shared
    
    init(frame: CGRect) {
        mapView = MKMapView(frame: frame)
        super.init()
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.delegate = self
        
        locationManager.startUpdatingLocation()
          locationManager.locationEventSink = { [weak self] data in
              guard let self = self else { return }
              if let latitude = data["latitude"] as? Double, let longitude = data["longitude"] as? Double {
                  let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                  self.setRegion(centerCoordinate: coordinate, radiusInMeters: 500)  // 500m 반경으로 설정
              }
          }
    }
    
    func setRegion(centerCoordinate: CLLocationCoordinate2D, radiusInMeters: Double) {
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: radiusInMeters, longitudinalMeters: radiusInMeters)
        mapView.setRegion(region, animated: true)
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
        
        setRegion(centerCoordinate: location.coordinate, radiusInMeters: 500)
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "course": location.course
        ]
        
        eventSink(locationData)
        print("Location data sent: \(locationData)")
    }
}
