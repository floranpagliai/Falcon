//
//  EWalletManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Firebase

class EWalletManager {
	
	// MARK: Properties
	let ref = FirebaseManager()
	let userManager = UserManager()
	
	func updateWalet() {
		let userRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: ref.userRef)
		let walletRef = ref.getPathRef("wallet", ref: userRef)
		
		walletRef.observeEventType (.ChildChanged, withBlock: { snapshot in
			var eWallet = [FalcoinAddress]()
			for children in snapshot.children {
				print(children)
				let falcoinAddress = FalcoinAddress(snapshot: children as! FDataSnapshot)
				print(falcoinAddress)
				eWallet.append(falcoinAddress)
			}
			DataManager.sharedInstance.eWallet = eWallet
		})
	}
	
	func newAdress() {
		let falcoinAddress = FalcoinAddress()
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		
		ref.save(falcoinAddressesRef, key: falcoinAddress.privateKey, data: falcoinAddress.toAnyObject())
		userManager.addAddress(falcoinAddress)
		
	}
	
}