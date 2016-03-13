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
	
	// MARK: View Properties
    @IBOutlet weak var mapButton: UIButton!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		ref = Firebase(url: "https://falcongame.firebaseio.com")
	}
	
	override func viewDidAppear(animated: Bool) {
		PersmissionManager.showPermisionDialog { (error) -> Void in }
	}
	
	// MARK: Actions
	@IBAction func logoutAction(sender: UIButton) {
		ref.unauth()
		//self.performSegueWithIdentifier("Logout", sender: nil)
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("LoginView")
		self.presentViewController(vc, animated: true, completion: nil)
	}
}