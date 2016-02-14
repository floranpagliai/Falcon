//
//  LoginViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 07/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase

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
	@IBAction func loginAction(sender: UIButton) {
		ref.authUser(loginTextField.text, password: passwordTextField.text,
			withCompletionBlock: { (error, auth) in
				if error != nil {
					print("login ko")
					// There was an error logging in to this account
				} else {
					print("login ok")
					// We are now logged in
					self.performSegueWithIdentifier("Logged", sender: self)
					
				}
		})
	}
	
	@IBAction func registerAction(sender: UIButton) {
		let alert = UIAlertController(title: "Register",
			message: "Register",
			preferredStyle: .Alert)
		
		let saveAction = UIAlertAction(title: "Save",
			style: .Default) { (action: UIAlertAction) -> Void in
				
				let emailField = alert.textFields![0]
				let passwordField = alert.textFields![1]
				self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
					// 2
					if error == nil {
						// 3
						self.ref.authUser(emailField.text, password: passwordField.text,
							withCompletionBlock: { (error, auth) -> Void in
						})
					}
				}
		}
		
		let cancelAction = UIAlertAction(title: "Cancel",
			style: .Default) { (action: UIAlertAction) -> Void in
		}
		
		alert.addTextFieldWithConfigurationHandler {
			(textEmail) -> Void in
			textEmail.placeholder = "Enter your email"
		}
		
		alert.addTextFieldWithConfigurationHandler {
			(textPassword) -> Void in
			textPassword.secureTextEntry = true
			textPassword.placeholder = "Enter your password"
		}
		
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		
		presentViewController(alert,
			animated: true,
			completion: nil)
	}
}
