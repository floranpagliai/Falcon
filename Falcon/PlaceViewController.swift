//
//  PlaceViewController.swift
//  Falcon
//
//  Created by Floran Pagliai on 20/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
	
	// MARK: Properties
	var placeMarker: PlaceMarker?
	var stopwatch: Stopwatch?
	let firabaseManager = FirebaseManager()
	let eWalletManager = EWalletManager()
	
	// MARK: View Properties
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeTypeLabel: UILabel!
	@IBOutlet weak var placeDistanceLabel: UILabel!
	@IBOutlet weak var hackProgressLabel: UILabel!
	@IBOutlet weak var hackButton: UIButton!
	@IBOutlet weak var eWalletButton: UIButton!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		self.view.layer.cornerRadius = 10;
		self.placeMarker = DataManager.sharedInstance.currentSelectedPlace
		self.placeNameLabel.text = self.placeMarker!.place.name
		self.placeTypeLabel.text = self.placeMarker!.place.getType()
		self.placeDistanceLabel.text = self.placeMarker!.getDistanceString() + " m"
		self.hackProgressLabel.text = ""
		self.eWalletButton.hidden = true
		self.update()
	}
	
	// MARK: Actions
	@IBAction func hackStartedAction(sender: UIButton) {
		if self.placeMarker?.hacked == false {
			self.hackProgressLabel.text = "Hack in progress..."
		} else {
			self.hackProgressLabel.text = "Disconnection"
		}
	}
	@IBAction func hackAction(sender: AnyObject) {
		self.stopwatch = Stopwatch()
		var time: NSTimeInterval
		if self.placeMarker?.hacked == false {
			time = NSTimeInterval(5)
			while time > stopwatch!.elapsedTimeInterval() {}
			self.placeMarker?.hacked = true
			self.eWalletButton.hidden = false
			self.hackProgressLabel.text = "Hacked in \(stopwatch!.elapsedTimeString())"
		} else {
			time = NSTimeInterval(0.5)
			while time > stopwatch!.elapsedTimeInterval() {}
			self.placeMarker?.hacked = false
			self.eWalletButton.hidden = true
			self.hackProgressLabel.text = ""
		}
		self.update()
	}
	
	@IBAction func eWalletAction(sender: AnyObject) {
		self.eWalletManager.getByKey((self.placeMarker?.place.wallet)!) {
			(error, falcoinAddress) -> Void in
			if(!error) {
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let transferController = storyboard.instantiateViewControllerWithIdentifier("TransferController") as! TransferController
				transferController.originAddress = falcoinAddress
				let navController = UINavigationController(rootViewController: transferController)
				self.presentViewController(navController, animated: true, completion: nil)
			}
		}
	}
	
	func update() {
		if self.placeMarker?.hacked == false {
			self.hackButton.setImage(UIImage(named: "lockButton"), forState: UIControlState.Normal)
		} else {
			self.hackButton.setImage(UIImage(named: "lockOpenButton"), forState: UIControlState.Normal)
		}
	}
}
