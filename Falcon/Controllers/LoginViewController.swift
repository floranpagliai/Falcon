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
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		ref = Firebase(url: "https://falcongame.firebaseio.com")
	}
	
	// MARK: Actions
	@IBAction func loginAction(sender: UIButton) {
//		ref.authUser(loginTextField.text, password: passwordTextField.text,
//			withCompletionBlock: { (error, auth) in
//				if error != nil {
//					// There was an error logging in to this account
//				} else {
//					// We are now logged in
//				}
//		})
	}
	
}
