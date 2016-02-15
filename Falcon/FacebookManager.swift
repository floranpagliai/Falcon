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
	
	static func registerUser(auth: FAuthData, token: String)  {
		
		let req = FBSDKGraphRequest(
			graphPath: "me",
			parameters: ["fields":"email,name"],
			tokenString: token, version: nil,
			HTTPMethod: "GET")
		req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
			if(error == nil) {
				let resultdict = result as? NSDictionary
				let newUser = [
					"provider": auth.provider,
					"username": resultdict?["name"] as? String,
					"email": resultdict?["email"] as? String
				]
				let ref = Firebase(url: "https://falcongame.firebaseio.com")
				ref.childByAppendingPath("users").childByAppendingPath(auth.uid).setValue(newUser)
			}
		})
	}
}
