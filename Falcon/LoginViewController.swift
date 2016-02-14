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
		ref.authUser(loginTextField.text, password: passwordTextField.text, withCompletionBlock: {
			(error, auth) in
			if error != nil {
				print("Login : Login ko")
				// There was an error logging in to this account
				// TODO: Add error message
			} else {
				print("Login : Login ok")
				// We are now logged in
				self.performSegueWithIdentifier("Logged", sender: nil)
//				self.presentViewController(HomeViewController(), animated: true, completion: nil)
			}
		})
	}
}
