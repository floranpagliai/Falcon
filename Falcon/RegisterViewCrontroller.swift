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
							self.presentViewController(LoginViewController(), animated: true, completion: nil)
						} else {
							print("Register : Login ok")
							self.presentViewController(HomeViewController(), animated: true, completion: nil)
						}
					})
				} else {
					print("Register : Register ko")
				}
		}
	}
}