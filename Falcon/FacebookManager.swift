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
	
	func getUserData(token: String, completionBlock: (result: NSDictionary) -> ())
	{
		let req = FBSDKGraphRequest(
			graphPath: "me",
			parameters: ["fields":"email,name"],
			tokenString: token, version: nil,
			HTTPMethod: "GET")
		req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
			if(error == nil) {
				completionBlock(result: (result as? NSDictionary)!)
				//resultdict = (result as? NSDictionary)!
			}
		})
	}

	static func registerUser(token: String)  {
		let req = FBSDKGraphRequest(
			graphPath: "me",
			parameters: ["fields":"email,name"],
			tokenString: token, version: nil,
			HTTPMethod: "GET")
		req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
			if(error == nil) {
				let ref = Firebase(url: "https://falcongame.firebaseio.com")
				let resultdict = result as? NSDictionary
				let newUser = [
					"provider": "facebook",
					"username": resultdict?["name"] as! String,
					"email": resultdict?["email"] as! String,
					"facebook_token": token
				]
				ref.createUser(newUser["email"], password: "floran") {
					(error: NSError!) in
					if error == nil {
						print("Register : Register ok")
						ref.authUser(newUser["email"], password: "test", withCompletionBlock: {
							(error, authData) in
							if error == nil {
								print("FacebookManager : Login ko")
							} else {
								print("FacebookManager : Login ok")
								ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
							}
						})
						
					} else {
						print("Register : Register ko")
					}
				}
			}
		})
	}
}
