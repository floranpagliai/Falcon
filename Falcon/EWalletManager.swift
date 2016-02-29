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
	
	func getWallet() {
		let userRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: ref.userRef)
		let walletRef = ref.getPathRef("wallet", ref: userRef)
		DataManager.sharedInstance.eWallet = [FalcoinAddress]()
		
		walletRef.observeEventType(.Value, withBlock: {
			(snapshot) in
			let enumerator = snapshot.children
			while let children = enumerator.nextObject() as? FDataSnapshot {
				let falcoinAddrsRef = self.ref.getPathRef(children.value as! String, ref: self.ref.falcoinAddrsRef)
				falcoinAddrsRef.observeEventType(.Value, withBlock: {
					(snapshot) in
					let falcoinAddress = FalcoinAddress(snapshot: snapshot, userWalletRef: children.ref)
					DataManager.sharedInstance.eWallet.append(falcoinAddress)
				})
			}
		})
	}
	
	func newAdress() {
		let falcoinAddress = FalcoinAddress()
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		let addressKey = ref.childByAutoId(falcoinAddressesRef, data: falcoinAddress.toAnyObject())
		
		userManager.addAddress(addressKey)
	}
	
	func removeAddress(falcoinAddress: FalcoinAddress) {
		falcoinAddress.userWalletRef!.removeValue()
	}
	
}