//
//  EWalletManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

class EWalletManager {
	
	// MARK: Properties
	let ref = FirebaseManager()
	let userManager = UserManager()
	
	func newAdress() {
		let falcoinAddress = FalcoinAddress()
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		
		ref.save(falcoinAddressesRef, key: falcoinAddress.privateKey, data: falcoinAddress.toAnyObject())
		userManager.addAddress(falcoinAddress)
		
	}
	
}