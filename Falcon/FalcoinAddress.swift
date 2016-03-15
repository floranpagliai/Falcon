//
//  FalcoinAddress.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//


import Firebase

struct FalcoinAddress {
	var publicKey: String!
	let privateKey: String!
	var balance: Int!
	let ref: Firebase?
	let userWalletRef: Firebase?
	
	// Initialize from arbitrary data
	init() {
		self.publicKey = ""
		self.privateKey = NSUUID().UUIDString
		self.balance = 0
		self.ref = nil
		self.userWalletRef = nil
	}
	
	init(snapshot: FDataSnapshot, userWalletRef: Firebase) {
		self.publicKey = snapshot.value["public_key"] as! String
		self.privateKey = snapshot.value["private_key"] as! String
		self.balance = snapshot.value["balance"] as! Int
		self.ref = snapshot.ref
		self.userWalletRef = userWalletRef
	}
	
	init(snapshot: FDataSnapshot) {
		self.publicKey = snapshot.value["public_key"] as! String
		self.privateKey = snapshot.value["private_key"] as! String
		self.balance = snapshot.value["balance"] as! Int
		self.ref = snapshot.ref
		self.userWalletRef = nil
	}
	
	func toAnyObject() -> [NSObject : AnyObject] {
		return [
			"public_key": self.publicKey,
			"private_key": self.privateKey,
			"balance": self.balance,
		]
	}
	
	func save() {
		self.ref?.updateChildValues(self.toAnyObject())
	}
}

extension FalcoinAddress: Hashable {
	var hashValue: Int {
		return privateKey.hashValue
	}
}


func ==(lhs: FalcoinAddress, rhs: FalcoinAddress) -> Bool {
	return lhs.privateKey == rhs.privateKey
}


