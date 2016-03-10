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
	
	func newPlaceAdress(placeKey: String) {
		var falcoinAddress = FalcoinAddress()
		falcoinAddress.balance = 1000
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		let addressKey = ref.childByAutoId(falcoinAddressesRef, data: falcoinAddress.toAnyObject())
		
		
		self.getNextKey { (error, key) -> Void in
			if (!error) {
				let walletRef = self.ref.getPathRef(placeKey, ref: self.ref.placesRef)
				self.ref.save(walletRef, key: "/wallet", data: addressKey as AnyObject)
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
	
	func get(publicKey: String, withCompletionBlock: (error: Bool, falcoinAddress: FalcoinAddress?) -> Void) {
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		
		falcoinAddressesRef.queryOrderedByChild("public_key").queryEqualToValue(Int(publicKey)).queryLimitedToFirst(1).observeEventType(.ChildAdded, withBlock: {
			(snapshot) in
			if snapshot.value is NSNull  {
				withCompletionBlock(error: true, falcoinAddress: nil)
			} else {
				let falcoinAddress = FalcoinAddress(snapshot: snapshot)
				withCompletionBlock(error: false, falcoinAddress: falcoinAddress)
			}
		})
		withCompletionBlock(error: true, falcoinAddress: nil)
	}
	
	func getByKey(key: String, withCompletionBlock: (error: Bool, falcoinAddress: FalcoinAddress?) -> Void) {
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses/"+key)
		
		falcoinAddressesRef.observeEventType(.Value, withBlock: {
			(snapshot) in
			if snapshot.value is NSNull  {
				withCompletionBlock(error: true, falcoinAddress: nil)
			} else {
				let falcoinAddress = FalcoinAddress(snapshot: snapshot)
				withCompletionBlock(error: false, falcoinAddress: falcoinAddress)
			}
		})
		withCompletionBlock(error: true, falcoinAddress: nil)
	}
	
	func transfer(inout originAddress: FalcoinAddress, inout destAddress: FalcoinAddress, amount: Int) {
		originAddress.balance = originAddress.balance - amount
		destAddress.balance = destAddress.balance + amount
		originAddress.save()
		destAddress.save()
	}
	
	func removeAddress(falcoinAddress: FalcoinAddress) {
		falcoinAddress.userWalletRef!.removeValue()
	}
	
}