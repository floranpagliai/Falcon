//
//  UserManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

class UserManager {
	
	// MARK: Properties
	let ref = FirebaseManager()
	
	func addAddress(falcoinAddress: FalcoinAddress) {
		let usersRef = ref.getPathRef("users")
		let userRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: usersRef)
		let walletRef = ref.getPathRef("wallet", ref: userRef)
		let test = [
			"id": falcoinAddress.privateKey
		]
		ref.childByAutoId(walletRef, data: test)
		DataManager.sharedInstance.eWallet?.append(falcoinAddress)
	}
}
