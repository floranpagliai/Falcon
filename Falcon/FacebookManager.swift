//
//  FacebookManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 15/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookManager {
	
	// MARK: Properties
	let ref = FirebaseManager()
	
	func getUserData(token: String, withCompletionBlock: (error: Bool, result: NSDictionary) -> Void) {
		let req = FBSDKGraphRequest(
			graphPath: "me",
			parameters: ["fields":"email,name"],
			tokenString: token, version: nil,
			HTTPMethod: "GET")
		req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
			if(error == nil) {
				withCompletionBlock(error: false, result: (result as? NSDictionary)!)
			} else {
				withCompletionBlock(error: true, result: NSDictionary())
			}
		})
	}

	func registerUser(token: String, withCompletionBlock: (error: Bool) -> Void)  {
		self.getUserData(token) {
			(error, result) -> Void in
			if (!error) {
				let password = self.randomStringWithLength(8)
				let newUser = [
					"provider": "facebook",
					"username": result["name"] as! String,
					"email": result["email"] as! String,
					"facebook_token": token
				]
				self.ref.registerUser(newUser, password: password, withCompletionBlock: { (error) -> Void in
					if (!error) {
						withCompletionBlock(error: false)
						print("FacebookManager : Register ok")
					} else {
						withCompletionBlock(error: true)
						print("FacebookManager : Register ko")
					}
				})
			} else {
				withCompletionBlock(error: true)
			}
		}
	}
	
	func randomStringWithLength(len: Int) -> String {
		
		let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		
		let randomString : NSMutableString = NSMutableString(capacity: len)
		
		for (var i=0; i < len; i++){
			let length = UInt32 (letters.length)
			let rand = arc4random_uniform(length)
			randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
		}
		
		return randomString as String
	}
}
