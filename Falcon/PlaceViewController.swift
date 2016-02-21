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
	
	// MARK: View Properties
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeTypeLabel: UILabel!
	@IBOutlet weak var placeDistanceLabel: UILabel!
	@IBOutlet weak var hackProgressLabel: UILabel!
	@IBOutlet weak var hackButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		self.view.layer.cornerRadius = 10;
		self.placeMarker = DataManager.sharedInstance.currentSelectedPlace
		self.placeNameLabel.text = self.placeMarker!.place.name
		self.placeTypeLabel.text = self.placeMarker!.place.getType()
		self.placeDistanceLabel.text = self.placeMarker!.getDistanceString() + " m"
		self.hackProgressLabel.text = ""
		self.update()
	}
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
			self.hackProgressLabel.text = "Hacked in \(stopwatch!.elapsedTimeString())"
		} else {
			time = NSTimeInterval(0.5)
			while time > stopwatch!.elapsedTimeInterval() {}
			self.placeMarker?.hacked = false
		}
		self.update()
	}
	
	func update() {
		if self.placeMarker?.hacked == false {
			self.hackButton.setImage(UIImage(named: "lockButton"), forState: UIControlState.Normal)
		} else {
			self.hackButton.setImage(UIImage(named: "lockOpenButton"), forState: UIControlState.Normal)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
