//
//  MapViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let camera = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
		let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//		mapView.myLocationEnabled = true
		mapView.settings.myLocationButton = true
//		self.view = mapView
		mapView.delegate = self
		self.view = mapView
		
	}
	
	// MARK: GMSMapViewDelegate
	
	func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
		print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
	}
}
