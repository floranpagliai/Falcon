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
import CryptoSwift
import Haneke
import JDStatusBarNotification

class LoginViewController: UIViewController {
	
	// MARK: Properties
	var ref: FirebaseManager!
	var fbm: FacebookManager!
	
	// MARK: View Properties
	@IBOutlet weak var loginTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var profileImageView: GravatarView!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = FirebaseManager()
		fbm = FacebookManager()
		
		loginTextField.autocorrectionType = UITextAutocorrectionType.No
	}
	
	// MARK: Actions
	@IBAction func emailEditingDidChange(sender: UITextField) {
		profileImageView.email = self.loginTextField.text
	}
	
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
				self.fbm.getUserPicture(facebookResult.token.tokenString, withCompletionBlock: { (error, result) -> Void in
					if (!error) {
						self.profileImageView.url = result
					}
				})
				self.fbm.registerUser(facebookResult.token.tokenString, withCompletionBlock: {
					(error) -> Void in
				})
				self.ref.loginOAuthUser("facebook", token: facebookResult.token.tokenString, withCompletionBlock: {
					(error) -> Void in
					if (!error) {
						self.performSegueWithIdentifier("Logged", sender: nil)
					}
				})
				
			}
		})
	}
	
	@IBAction func loginAction(sender: UIButton) {
		ref.loginUser(loginTextField.text!, password: passwordTextField.text!) {
			(error, message) -> Void in
			if (!error) {
				self.performSegueWithIdentifier("Logged", sender: nil)
			} else {
				// There was an error logging in to this account
				// TODO: Add error message
				JDStatusBarNotification.showWithStatus(message, dismissAfter: NSTimeInterval(5), styleName: JDStatusBarStyleError)
				self.loginTextField.layer.borderColor = UIColor.redColor().CGColor
				self.loginTextField.layer.borderWidth = 1.0
				self.passwordTextField.layer.borderColor = UIColor.redColor().CGColor
				self.passwordTextField.layer.borderWidth = 1.0
			}
		}
	}
	
	/**
	* Called when the user click on the view (outside the UITextField).
	*/
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
}
