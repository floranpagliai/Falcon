//
//  PlaceMarker.swift
//  Falcon
//
//  Created by Floran Pagliai on 19/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
	let place: Place
 
	init(place: Place) {
		self.place = place
		super.init()
		
		position = place.coordinate
		icon = UIImage(named: place.type.rawValue + "Marker")
//		icon = UIImage(named: "bankMarker")
		groundAnchor = CGPoint(x: 0.5, y: 1)
		appearAnimation = kGMSMarkerAnimationPop
	}
	
	func getDistance(fromLocation: CLLocation) -> Double {
		let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		return location.distanceFromLocation(fromLocation)
	}
	
	func getDistanceString(fromLocation: CLLocation) -> String {
		let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		return String(format:"%.0f", location.distanceFromLocation(fromLocation))
	}
}
