//
//  MapViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CCMRadarView

class MapViewController: UIViewController {
	
	// MARK: Properties
	let locationManager = CLLocationManager()
	let geocoder = GMSGeocoder()
	let placesClient = GMSPlacesClient()
	let mapZoom: Float = 18
	let mapViewingAngle: Double = 42
	let placeManager = PlacesManager()
	let searchRadius: Double = 1000
	var placeViewController: UIViewController?
	
	// MARK: View Properties
	@IBOutlet weak var mapView: GMSMapView! = GMSMapView()
	@IBOutlet weak var placeView: UIView!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeDistanceLabel: UILabel!
	@IBOutlet weak var radarView: CCMRadarView!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		mapView.delegate = self
		
//		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.startUpdatingLocation()
		
		mapView.camera = GMSCameraPosition(target: locationManager.location!.coordinate, zoom: self.mapZoom, bearing: 0, viewingAngle: self.mapViewingAngle)
		
		mapView.settings.setAllGesturesEnabled(false)
		mapView.myLocationEnabled = true
		mapView.settings.myLocationButton = true
		
		self.placeView.hidden = true
		self.radarView.hidden = true
	}
	
	override func viewDidAppear(animated: Bool) {
		PersmissionManager.showPermisionDialog {
			(error) -> Void in
			if (error) {
				self.performSegueWithIdentifier("Home", sender: nil)
			}
		}
	}
	
	// MARK: Actions
	@IBAction func scanAction(sender: UIButton) {
		self.radarView.hidden = false
		self.radarView.startAnimation()
		self.hidePlaceInfo()
		let stopwatch = Stopwatch()
		let time = NSTimeInterval(3)
		mapView.clear()
		self.placeManager.fetchNearPlaces {
			(places) -> Void in
			while time > stopwatch.elapsedTimeInterval() {}
			for place: Place in places {
				let marker = PlaceMarker(place: place)
				marker.map = self.mapView
			}
			self.radarView.hidden = true
			self.radarView.stopAnimation()
		}
	}
	
	func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
		geocoder.reverseGeocodeCoordinate(coordinate) {
			response, error in
			if let address = response?.firstResult() {
				let lines = address.lines as! [String]
				self.locationLabel.text = lines.joinWithSeparator("\n")
				let labelHeight = self.locationLabel.intrinsicContentSize().height
				self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
				UIView.animateWithDuration(0.25) {
					self.view.layoutIfNeeded()
				}
			}
		}
	}
	
	func showPlaceInfo(placeMarker: PlaceMarker) {
		DataManager.sharedInstance.currentSelectedPlace = placeMarker
		placeViewController = PlaceViewController()
		self.placeView.hidden = false
		//Add PlaceViewController to PlaceView Container
		addChildViewController(placeViewController!)
		placeViewController!.view.frame = placeView.bounds
		placeView.addSubview(placeViewController!.view)
		placeViewController!.didMoveToParentViewController(self)
	}
	
	func hidePlaceInfo() {
		mapView.animateToLocation(locationManager.location!.coordinate)
		self.placeView.hidden = true
		if let activeVC = placeViewController {
			activeVC.willMoveToParentViewController(nil)
			activeVC.view.removeFromSuperview()
			activeVC.removeFromParentViewController()
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
			print("MapView : location updated")
			mapView.animateToLocation(location.coordinate)
			locationManager.stopUpdatingLocation()
		}
	}
}

extension MapViewController: GMSMapViewDelegate {
	
	// MARK: GMSMapViewDelegate
	func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
		reverseGeocodeCoordinate(locationManager.location!.coordinate)
	}
	
	func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
	  mapView.animateToLocation(locationManager.location!.coordinate)
	  mapView.selectedMarker = nil
	  self.hidePlaceInfo()
	  return true
	}
	
	func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
		let placeMarker = marker as! PlaceMarker

		self.showPlaceInfo(placeMarker)
		mapView.animateToLocation(placeMarker.place.coordinate)
		return true
	}
	
	func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
		self.hidePlaceInfo()
		print("MapView : tap")
	}
}