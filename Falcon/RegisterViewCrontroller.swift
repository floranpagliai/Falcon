//
//  RegisterViewCrontroller.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase
import JDStatusBarNotification

class RegisterViewController: UIViewController {
	
	// MARK: Properties
	var ref: FirebaseManager!
	
	// MARK: View Properties
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = FirebaseManager()
		
		emailTextField.autocorrectionType = UITextAutocorrectionType.No
	}
	
	// MARK: Actions
	@IBAction func registerAction(sender: UIButton) {
		let userData = [
			"provider": "password",
			"username": usernameTextField.text!,
			"email": emailTextField.text!
		]
		ref.registerUser(userData, password: passwordTextField.text!) {
			(error, message) -> Void in
			if (!error) {
				self.performSegueWithIdentifier("Logged", sender: nil)
			} else {
				JDStatusBarNotification.showWithStatus(message, dismissAfter: NSTimeInterval(5), styleName: JDStatusBarStyleError)
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