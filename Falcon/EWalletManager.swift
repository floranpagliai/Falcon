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
	
	func newAdress() {
		var falcoinAddress = FalcoinAddress()
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		let addressKey = ref.childByAutoId(falcoinAddressesRef, data: falcoinAddress.toAnyObject())
		
		
		self.getNextKey { (error, key) -> Void in
			if (!error) {
				self.userManager.addAddress(addressKey)
				falcoinAddress.publicKey = key
				self.ref.update(falcoinAddressesRef, key: addressKey, data: falcoinAddress.toAnyObject())
			}
		}
	}
	
	func getNextKey(withCompletionBlock: (error: Bool, key: Int) -> Void) {
		let addressesKey = self.ref.falcoinAddrsKeyRef
		
		addressesKey.runTransactionBlock({
			(currentData:FMutableData!) in
			var value = currentData.value as? Int
			if (value == nil) {
				value = 0
			} else {
				
				withCompletionBlock(error: false, key: value! + 1)
			}
			currentData.value = value! + 1
			return FTransactionResult.successWithValue(currentData)
		})
	}
	
	func removeAddress(falcoinAddress: FalcoinAddress) {
		falcoinAddress.userWalletRef!.removeValue()
	}
	
}