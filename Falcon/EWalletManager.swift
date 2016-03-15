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
	
	func getNextKey(withCompletionBlock: (error: Bool, key: String) -> Void) {
		let addressesKey = self.ref.falcoinAddrsKeyRef
		
		addressesKey.runTransactionBlock({
			(currentData:FMutableData!) in
			if (currentData.value is NSNull) {
				currentData.value = "A1"
			} else {
				currentData.value = self.incrementPublicKey(currentData.value as! String)
				withCompletionBlock(error: false, key: currentData.value as! String)
			}
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
	
	func suffixNumber(number:NSNumber) -> NSString {
		
		var num:Double = number.doubleValue;
		let sign = ((num < 0) ? "-" : "" );
		
		num = fabs(num);
		
		if (num < 10000.0){
			return "\(sign)\(Int(num))";
		}
		
		let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
		
		let units:[String] = ["K","M","G","T","P","E"];
		
		let roundedNum:Double = 10 * num / pow(1000.0,Double(exp)) / 10;
		
		return "\(sign)\(roundedNum)\(units[exp-1])";
	}
	
	func incrementPublicKey(publicKey: String) -> String {
		var letter: String
		let NSPublicKey = publicKey as NSString
		var number = Int(NSPublicKey.substringWithRange(NSRange(location: 1, length: publicKey.characters.count - 1)))!
		
		switch NSPublicKey.substringWithRange(NSRange(location: 0, length: 1)) {
			case "A":
			letter = "B"
			case "B":
			letter = "C"
			default:
			letter = "A"
			number = number + 1
		}
		
		return letter + String(number)
	}

	
}