//
//  FirebaseManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 16/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Firebase

class FirebaseManager {
	
	// MARK: Properties
	let ref = Firebase(url: "https://falcongame.firebaseio.com")
	
	func getPathRef(path: String) -> Firebase {
		return self.ref.childByAppendingPath(path)
	}
	
	func getPathRef(path: String, ref: Firebase) -> Firebase {
		return ref.childByAppendingPath(path)
	}
	
	func loginUser(email: String, password: String, withCompletionBlock: (error: Bool) -> Void) {
		ref.authUser(email, password: password, withCompletionBlock: {
			(error, auth) in
			if error == nil {
				withCompletionBlock(error: false)
				print("FirebaseManager : Login ok")
			} else {
				withCompletionBlock(error: true)
				print("FirebaseManager : Login ko")
			}
		})
	}
	
	func loginOAuthUser(provider: String, token: String, withCompletionBlock: (error: Bool) -> Void) {
		ref.authWithOAuthProvider(provider, token: token, withCompletionBlock: {
			(error, auth) in
			if error == nil {
				withCompletionBlock(error: false)
				print("FirebaseManager : Login OAuth ok")
			} else {
				withCompletionBlock(error: true)
				print("FirebaseManager : Login OAuth ko")
			}
		})
	}
	
	func registerUser(userData: [String: String], password: String, withCompletionBlock: (error: Bool) -> Void) {
		self.ref.createUser(userData["email"], password: password, withValueCompletionBlock : {
			(error: NSError!, result) in
			if error == nil {
				let uid = result["uid"] as? String
				self.ref.childByAppendingPath("users").childByAppendingPath(uid).setValue(userData)
				withCompletionBlock(error: false)
				print("FirebaseManager : Register ok")
			} else {
				withCompletionBlock(error: true)
				print("FirebaseManager : Register ko")
			}
		})
	}
	
	func save(ref: Firebase, key: String, data: [NSObject : AnyObject]) {
		ref.childByAppendingPath(key).setValue(data)
	}
	
	func update(ref: Firebase, key: String, data: [NSObject : AnyObject]) {
		ref.childByAppendingPath(key).updateChildValues(data)
	}
	
}