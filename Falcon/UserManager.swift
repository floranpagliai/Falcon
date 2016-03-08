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
	
	func getUser(withCompletionBlock: (user: User) -> Void) {
		ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: ref.userRef).observeEventType(.Value, withBlock: {
			(snapshot) in
			print(snapshot)
			withCompletionBlock(user: User(snapshot: snapshot))
		})
	}
	
	func addAddress(falcoinAddressKey: String) {
		let walletRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!+"/wallet", ref: ref.userRef)
		ref.childByAutoId(walletRef, data: falcoinAddressKey as AnyObject)
	}
}
