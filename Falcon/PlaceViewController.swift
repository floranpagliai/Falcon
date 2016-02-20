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
	
	// MARK: View Properties
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var placeTypeLabel: UILabel!
	@IBOutlet weak var placeDistanceLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.layer.cornerRadius = 10;
		self.placeMarker = DataManager.sharedInstance.currentSelectedPlace
		self.placeNameLabel.text = self.placeMarker!.place.name
		self.placeTypeLabel.text = self.placeMarker!.place.getType()
		self.placeDistanceLabel.text = self.placeMarker!.getDistanceString() + " m"
	}
	@IBAction func hackAction(sender: AnyObject) {
		print("hack")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
