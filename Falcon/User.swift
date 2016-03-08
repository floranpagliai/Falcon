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
	init(id: String, username: String, address: String, email: String) {
		self.id = id
		self.username = username
		self.email = email
		self.ref = nil
	}
	
	init(snapshot: FDataSnapshot) {
		self.id = snapshot.key
		self.username = snapshot.value["username"] as! String
		self.email = snapshot.value["email"] as! String
		self.ref = snapshot.ref
	}
	
	func toAnyObject() -> [NSObject : AnyObject] {
		return [
			"username": self.username,
			"email": self.email,
		]
	}

}
