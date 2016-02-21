//
//  FalcoinAddress.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//


import Firebase

struct FalcoinAdress {
	let id: String!
	let publicKey: String!
	let privateKey: String!
	let balance: Float!
	let ref: Firebase?
	
	// Initialize from arbitrary data
	init(id: String) {
		self.id = id
		self.publicKey = "public"
		self.privateKey = NSUUID().UUIDString
		self.balance = 0
		self.ref = nil
	}
	
	init(snapshot: FDataSnapshot) {
		self.id = snapshot.key
		self.publicKey = snapshot.value["publicKey"] as! String
		self.privateKey = snapshot.value["privateKey"] as! String
		self.balance = snapshot.value["balance"] as! Float
		self.ref = snapshot.ref
	}
	
	func toAnyObject() -> [NSObject : AnyObject] {
		return [
			"public_key": self.publicKey,
			"private_key": self.privateKey,
			"balance": self.balance,
		]
	}
	
}

