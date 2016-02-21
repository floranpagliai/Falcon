//
//  HomeViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
	
	// MARK: Properties
	var ref: Firebase!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = Firebase(url: "https://falcongame.firebaseio.com")
	}
	
	override func viewDidAppear(animated: Bool) {
		PersmissionManager.showPermisionDialog { (error) -> Void in }
	}
	
	@IBAction func logoutAction(sender: UIButton) {
		ref.unauth()
		self.performSegueWithIdentifier("Logout", sender: nil)
	}
}