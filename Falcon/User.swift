//
//  User.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Firebase
import GoogleMaps

struct User {
	let id: String!
	let username: String!
	let email: String!
//	let coordinate: CLLocationCoordinate2D
	let ref: Firebase?
	
	// Initialize from arbitrary data
	init(id: String, username: String, address: String, email: String, coordinate: CLLocationCoordinate2D) {
		self.id = id
		self.username = username
		self.email = email
//		self.coordinate = coordinate
		self.ref = nil
	}
	
	init(snapshot: FDataSnapshot) {
		self.id = snapshot.key
		self.username = snapshot.value["username"] as! String
		self.email = snapshot.value["email"] as! String
//		self.coordinate = CLLocationCoordinate2D(
//			latitude: snapshot.value["latitude"] as! CLLocationDegrees,
//			longitude: snapshot.value["longitude"] as! CLLocationDegrees)
		self.ref = snapshot.ref
	}
	
	func toAnyObject() -> [NSObject : AnyObject] {
		return [
			"username": self.username,
			"email": self.email,
//			"latitude": self.coordinate.latitude,
//			"longitude": self.coordinate.longitude
		]
	}

}
