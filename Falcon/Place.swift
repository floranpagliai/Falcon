//
//  Place.swift
//  Falcon
//
//  Created by Floran Pagliai on 18/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Firebase
import GoogleMaps

enum PlaceType {
	case bank
	case restaurant
	case school
	case store
}

struct Place {
	
	let id: String!
	let name: String!
	let address: String!
	let types: [PlaceType]
	let coordinate: CLLocationCoordinate2D
	let ref: Firebase?
	
	// Initialize from arbitrary data
	init(id: String, name: String, address: String, types: [PlaceType], coordinate: CLLocationCoordinate2D) {
		self.id = id
		self.name = name
		self.address = address
		self.types = types
		self.coordinate = coordinate
		self.ref = nil
	}
	
	init(snapshot: FDataSnapshot) {
		self.id = snapshot.key
		self.name = snapshot.value["name"] as! String
		self.address = snapshot.value["address"] as! String
		self.types = snapshot.value["types"] as! [PlaceType]
		self.coordinate = CLLocationCoordinate2D(
			latitude: snapshot.value["latitude"] as! CLLocationDegrees,
			longitude: snapshot.value["longitude"] as! CLLocationDegrees)
		self.ref = snapshot.ref
	}
	
	func toAnyObject() ->  AnyObject {
		return [
			"name": name,
			"address": address,
//			"latitude": coordinate.latitude,
//			"longitude": coordinate.longitude
		]
	}
}
