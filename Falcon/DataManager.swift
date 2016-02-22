//
//  DataManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 20/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import Foundation

class DataManager {
	static let sharedInstance = DataManager()
	var currentSelectedPlace: PlaceMarker?
	var eWallet = [FalcoinAddress]()
	var currentUser: User? {
		didSet {
			print("DataManager : currentUser setted (\(self.currentUser!.id))")
		}
	}
	
	init() {
		self.currentSelectedPlace = nil
	}
}