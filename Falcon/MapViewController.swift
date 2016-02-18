//
//  MapViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
	
	// MARK: Properties
	let locationManager = CLLocationManager()
	let geocoder = GMSGeocoder()
	let mapZoom: Float = 18
	let mapViewingAngle: Double = 20
	
	// MARK: View Properties
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var mapView: GMSMapView! = GMSMapView()
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		mapView.delegate = self
		
		locationManager.requestWhenInUseAuthorization()
		
		mapView.settings.setAllGesturesEnabled(false)
		mapView.myLocationEnabled = true
		mapView.settings.myLocationButton = false
	}
	
	func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
		geocoder.reverseGeocodeCoordinate(coordinate) {
			response, error in
			if let address = response?.firstResult() {
				let labelHeight = self.locationLabel.intrinsicContentSize().height
				self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
				
				self.locationLabel.text = address.thoroughfare + "\n" + address.locality
				UIView.animateWithDuration(0.25) {
					self.view.layoutIfNeeded()
				}
				
				
			}
		}
	}
}

extension MapViewController: CLLocationManagerDelegate {
	
	// MARK: - CLLocationManagerDelegate
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			locationManager.startUpdatingLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			
			mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: self.mapZoom, bearing: 0, viewingAngle: self.mapViewingAngle)
//			locationManager.stopUpdatingLocation()
		}
	}
}

extension MapViewController: GMSMapViewDelegate {
	
	// MARK: GMSMapViewDelegate
	func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
		reverseGeocodeCoordinate(position.target)
	}
}