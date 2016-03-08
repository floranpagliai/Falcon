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
	
	func getUserPicture(token: String, withCompletionBlock: (error: Bool, result: String) -> Void) {
		let req = FBSDKGraphRequest(
			graphPath: "me",
			parameters: ["fields":"picture"],
			tokenString: token, version: nil,
			HTTPMethod: "GET")
		req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
			if(error == nil) {
				let resultdic = result as! NSDictionary
				let url = resultdic["picture"]!["data"]!!["url"] as! String
				withCompletionBlock(error: false, result: url)
			} else {
				withCompletionBlock(error: true, result: String())
			}
		})
	}

	func registerUser(token: String, withCompletionBlock: (error: Bool) -> Void)  {
		self.getUserData(token) {
			(error, result) -> Void in
			if (!error) {
				let newUser = [
					"provider": "facebook",
					"username": result["name"] as! String,
					"email": result["email"] as! String,
					"facebook_id": result["id"] as! String,
					"facebook_token": token,
				]
				self.ref.update(self.ref.userRef, key: "facebook:"+newUser["facebook_id"]!, data: newUser)
				withCompletionBlock(error: false)
				print("FacebookManager : Register ok")
			} else {
				withCompletionBlock(error: true)
			}
		}
	}
}
