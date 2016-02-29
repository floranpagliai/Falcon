//
//  FalcoinAddress.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//


import Firebase

struct FalcoinAddress {
	let publicKey: Int!
	let privateKey: String!
	let balance: Float!
	let ref: Firebase?
	let userWalletRef: Firebase?
	
	// Initialize from arbitrary data
	init() {
		self.publicKey = 1
		self.privateKey = NSUUID().UUIDString
		self.balance = 0
		self.ref = nil
		self.userWalletRef = nil
	}
	
	init(snapshot: FDataSnapshot, userWalletRef: Firebase) {
		self.publicKey = snapshot.value["public_key"] as! Int
		self.privateKey = snapshot.value["private_key"] as! String
		self.balance = snapshot.value["balance"] as! Float
		self.ref = snapshot.ref
		self.userWalletRef = userWalletRef
	}
	
	func toAnyObject() -> [NSObject : AnyObject] {
		return [
			"public_key": self.publicKey,
			"private_key": self.privateKey,
			"balance": self.balance,
		]
	}
	
}

