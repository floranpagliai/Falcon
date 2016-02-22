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
		let userRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: ref.userRef)
		let walletRef = ref.getPathRef("wallet", ref: userRef)
		let test = [
			"id": falcoinAddress.privateKey
		]
		ref.childByAutoId(walletRef, data: test)
		DataManager.sharedInstance.eWallet.append(falcoinAddress)
	}
}
