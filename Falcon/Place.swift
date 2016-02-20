//
//  Place.swift
//  Falcon
//
//  Created by Floran Pagliai on 18/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Firebase
import GoogleMaps

enum PlaceType : String {
	case unknow = "unknow"
	case bank = "bank"
	case restaurant = "restaurant"
	case school = "school"
	case store = "store"
}

struct Place {
	
	let id: String!
	let name: String!
	let address: String!
	let type: PlaceType
	let coordinate: CLLocationCoordinate2D
	let ref: Firebase?
	
	// Initialize from arbitrary data
	init(id: String, name: String, address: String, type: PlaceType, coordinate: CLLocationCoordinate2D) {
		self.id = id
		self.name = name
		self.address = address
		self.type = type
		self.coordinate = coordinate
		self.ref = nil
	}
	
	init(snapshot: FDataSnapshot) {
		self.id = snapshot.key
		self.name = snapshot.value["name"] as! String
		self.address = snapshot.value["address"] as! String
		self.type = snapshot.value["type"] as! PlaceType
		self.coordinate = CLLocationCoordinate2D(
			latitude: snapshot.value["latitude"] as! CLLocationDegrees,
			longitude: snapshot.value["longitude"] as! CLLocationDegrees)
		self.ref = snapshot.ref
	}
	
	func getType() -> String{
		return self.type.rawValue.capitalizedString
	}
	
	func toAnyObject() -> [NSObject : AnyObject] {
		return [
			"name": self.name,
			"address": self.address,
			"type": type.rawValue,
			"latitude": self.coordinate.latitude,
			"longitude": self.coordinate.longitude
		]
	}
}
