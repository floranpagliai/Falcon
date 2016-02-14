//
//  RegisterViewCrontroller.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
	
	// MARK: Properties
	var ref: Firebase!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = Firebase(url: "https://falcongame.firebaseio.com")
		
		emailTextField.autocorrectionType = UITextAutocorrectionType.No
	}
	
	// MARK: Actions
	@IBAction func registerAction(sender: UIButton) {
		ref.createUser(emailTextField.text,
			password: passwordTextField.text) {
				(error: NSError!) in
				if error == nil {
					self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: {
						(error, auth) in
						if error != nil {
							print("Register : Login ko")
							self.performSegueWithIdentifier("Login", sender: nil)
						} else {
							print("Register : Login ok")
							let newUser = [
								"provider": auth.provider,
								"username": self.usernameTextField.text,
								"email": self.emailTextField.text
							]
							self.ref.childByAppendingPath("users").childByAppendingPath(auth.uid).setValue(newUser)
							self.performSegueWithIdentifier("Logged", sender: nil)
						}
					})
				} else {
					print("Register : Register ko")
				}
		}
	}
}