//
//  LoginViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 07/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
	
	// MARK: Properties
	var ref: Firebase!
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = Firebase(url: "https://falcongame.firebaseio.com")
		
		loginTextField.autocorrectionType = UITextAutocorrectionType.No
	}
	
	// MARK: Actions
	@IBAction func loginFacebookAction(sender: UIButton) {
		let facebookLogin = FBSDKLoginManager()
		
		facebookLogin.loginBehavior = FBSDKLoginBehavior.SystemAccount
		facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {
			(facebookResult, facebookError) -> Void in
			if facebookError != nil {
				print("Login : Facebook login failed. Error \(facebookError)")
			} else if facebookResult.isCancelled {
				print("Login : Facebook login was cancelled.")
			} else {
				let req = FBSDKGraphRequest(
					graphPath: "me",
					parameters: ["fields":"email,name"],
					tokenString: facebookResult.token.tokenString, version: nil,
					HTTPMethod: "GET")
				req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
					if(error == nil) {
						let ref = Firebase(url: "https://falcongame.firebaseio.com")
						let password = self.randomStringWithLength(8)
						let resultdict = result as? NSDictionary
						let newUser = [
							"provider": "facebook",
							"username": resultdict!["name"] as! String,
							"email": resultdict!["email"] as! String,
							"facebook_token": facebookResult.token.tokenString
						]
						ref.createUser(newUser["email"], password: password, withValueCompletionBlock: {
							(error, result) in
							if error == nil {
								print("Register : Register ok")
								let uid = result["uid"] as? String
								ref.childByAppendingPath("users").childByAppendingPath(uid).setValue(newUser)
								//								ref.authUser(newUser["email"], password: password, withCompletionBlock: {
								//									(error, authData) in
								//									if error == nil {
								//										print("FacebookManager : Login ok")
								//										self.performSegueWithIdentifier("Logged", sender: nil)
								//									} else {
								//										print("FacebookManager : Login ko")
								//									}
								//								})
								
							} else {
								print("Register : Register ko")
							}
							ref.authWithOAuthProvider("facebook", token: facebookResult.token.tokenString,
								withCompletionBlock: {
									(error, authData) in
									if error != nil {
										print("Login failed. \(error)")
									} else {
										print("Logged in! \(authData)")
										self.performSegueWithIdentifier("Logged", sender: nil)
									}
							})
						})
					}
				})
			}
		})
	}
	
	@IBAction func loginAction(sender: UIButton) {
		ref.authUser(loginTextField.text, password: passwordTextField.text, withCompletionBlock: {
			(error, auth) in
			if error != nil {
				print("Login : Login ko")
				// There was an error logging in to this account
				// TODO: Add error message
				
				self.loginTextField.layer.borderColor = UIColor.redColor().CGColor
				self.loginTextField.layer.borderWidth = 1.0
				self.loginTextField.layer.cornerRadius = 8
				self.passwordTextField.layer.borderColor = UIColor.redColor().CGColor
				self.passwordTextField.layer.borderWidth = 1.0
				self.passwordTextField.layer.cornerRadius = 8
			} else {
				print("Login : Login ok")
				// We are now logged in
				self.performSegueWithIdentifier("Logged", sender: nil)
			}
		})
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
