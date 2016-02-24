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
	let userRef = Firebase(url: "https://falcongame.firebaseio.com/users")
	let falcoinAddrsRef = Firebase(url: "https://falcongame.firebaseio.com/falcoin_addresses")

	
	init() {
		//		Firebase.defaultConfig().persistenceEnabled = true
	}
	
	func getAuthData() -> FAuthData? {
		if self.ref.authData != nil {
			return self.ref.authData
		} else {
			return nil
		}
	}
	
	func getPathRef(path: String) -> Firebase {
		return self.ref.childByAppendingPath(path)
	}
	
	func getPathRef(path: String, ref: Firebase) -> Firebase {
		return ref.childByAppendingPath(path)
	}
	
	func getUser(withCompletionBlock: (user: User) -> Void) {
		self.getPathRef(self.ref.authData.uid, ref: self.userRef).observeEventType(.Value, withBlock: {
			(snapshot) in
			withCompletionBlock(user: User(snapshot: snapshot))
		})
	}
	
	func loginUser(email: String, password: String, withCompletionBlock: (error: Bool, message: String?) -> Void) {
		ref.authUser(email, password: password, withCompletionBlock: {
			(error, auth) in
			if error == nil {
				withCompletionBlock(error: false, message: nil)
				self.getUser({ (user) -> Void in
					DataManager.sharedInstance.currentUser = user
				})
				print("FirebaseManager : Login ok")
			} else {
				if let errorCode = FAuthenticationError(rawValue: error.code) {
					switch (errorCode) {
					case .UserDoesNotExist:
						withCompletionBlock(error: true, message: "No user found")
					case .InvalidEmail:
						withCompletionBlock(error: true, message: "Invalid email")
					case .InvalidPassword:
						withCompletionBlock(error: true, message: "Invalid password or maybe you have been hacked")
					default:
						withCompletionBlock(error: true, message: "Error")
					}
				}
				print("FirebaseManager : Login ko")
			}
		})
	}
	
	func loginOAuthUser(provider: String, token: String, withCompletionBlock: (error: Bool) -> Void) {
		ref.authWithOAuthProvider(provider, token: token, withCompletionBlock: {
			(error, auth) in
			if error == nil {
				withCompletionBlock(error: false)
				self.getUser({ (user) -> Void in
					DataManager.sharedInstance.currentUser = user
				})
				print("FirebaseManager : Login OAuth ok")
			} else {
				withCompletionBlock(error: true)
				print("FirebaseManager : Login OAuth ko")
			}
		})
	}
	
	func registerUser(userData: [String: String], password: String, withCompletionBlock: (error: Bool, message: String?) -> Void) {
		self.ref.createUser(userData["email"], password: password, withValueCompletionBlock : {
			(error: NSError!, result) in
			if error == nil {
				let uid = result["uid"] as? String
				self.ref.childByAppendingPath("users").childByAppendingPath(uid).setValue(userData)
				withCompletionBlock(error: false, message: nil)
				print("FirebaseManager : Register ok")
			} else {
				if let errorCode = FAuthenticationError(rawValue: error.code) {
					switch (errorCode) {
					case .EmailTaken:
						withCompletionBlock(error: true, message: "Email already taken")
					case .InvalidEmail:
						withCompletionBlock(error: true, message: "Invalid email")
					default:
						withCompletionBlock(error: true, message: "Error")
					}
				}
				print("FirebaseManager : Register ko")
			}
		})
	}
	
	func save(ref: Firebase, key: String, data: [NSObject : AnyObject]) {
		ref.childByAppendingPath(key).setValue(data)
	}
	
	func save(ref: Firebase, key: String, data: AnyObject) {
		ref.childByAppendingPath(key).setValue(data)
	}
	
	func update(ref: Firebase, key: String, data: [NSObject : AnyObject]) {
		ref.childByAppendingPath(key).updateChildValues(data)
	}
	
	func childByAutoId(ref: Firebase, data: [NSObject : AnyObject]) -> String {
		let childRef = ref.ref.childByAutoId()
		childRef.setValue(data)
		return childRef.key
	}
	
	func childByAutoId(ref: Firebase, data: AnyObject) -> String {
		let childRef = ref.ref.childByAutoId()
		childRef.setValue(data)
		return childRef.key
	}
	
	func unauth() {
		self.ref.unauth()
	}
}