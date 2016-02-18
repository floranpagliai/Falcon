//
//  MapViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
	
	// MARK: Properties
	let locationManager = CLLocationManager()
	var mapView = GMSMapView()
	let mapZoom: Float = 18
	let mapViewingAngle: Double = 20
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		mapView.delegate = self
		
		locationManager.requestWhenInUseAuthorization()
		
		mapView.settings.setAllGesturesEnabled(false)
		mapView.myLocationEnabled = true
		mapView.settings.myLocationButton = false
		self.view = mapView
	}
	
	// MARK: GMSMapViewDelegate
	func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
		print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
	}
	
	// MARK: - CLLocationManagerDelegate
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			locationManager.startUpdatingLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			
			mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: self.mapZoom, bearing: 0, viewingAngle: self.mapViewingAngle)
			locationManager.stopUpdatingLocation()
		}
		
	}
}