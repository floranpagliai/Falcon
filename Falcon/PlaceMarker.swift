//
//  PlaceMarker.swift
//  Falcon
//
//  Created by Floran Pagliai on 19/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
	let place: Place
 
	init(place: Place) {
		self.place = place
		super.init()
		
		position = place.coordinate
		icon = UIImage(named: "marker")
		groundAnchor = CGPoint(x: 0.5, y: 1)
		appearAnimation = kGMSMarkerAnimationPop
	}
}
