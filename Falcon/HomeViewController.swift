//
//  HomeViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 14/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate {
	
	// MARK: Properties
	var ref: Firebase!
    @IBOutlet weak var homeMap: UIButton!
    @IBOutlet weak var homeLogout: UIButton!
    
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
        let colorBorder = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
       
		ref = Firebase(url: "https://falcongame.firebaseio.com")
	}
	
	override func viewDidAppear(animated: Bool) {
		PersmissionManager.showPermisionDialog { (error) -> Void in }
	}
	
	// MARK: Actions
	@IBAction func logoutAction(sender: UIButton) {
		ref.unauth()
		self.performSegueWithIdentifier("Logout", sender: nil)
	}
    
}