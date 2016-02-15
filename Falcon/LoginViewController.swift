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
				FacebookManager.registerUser(facebookResult.token.tokenString)
				self.performSegueWithIdentifier("Logged", sender: nil)
//				let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
//				self.ref.authWithOAuthProvider("facebook", token: accessToken,
//					withCompletionBlock: { error, auth in
//						if error != nil {
//							print("Login : Facebook login ko")
//						} else {
//							print("Login : Facebook login ok")
//							FacebookManager.registerUser(auth, token: facebookResult.token.tokenString)
//							self.performSegueWithIdentifier("Logged", sender: nil)
//						}
//				})
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
}
