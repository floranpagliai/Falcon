//
//  EWalletController.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit

class EWalletController: UIViewController {
	
	// MARK: Properties
	let walletManager = EWalletManager()

	
	// MARK: View Properties

	
	// MARK: UIViewController Lifecycle
	
	// MARK: Actions
	@IBAction func addAddressAction(sender: UIBarButtonItem) {
		walletManager.newAdress()
	}
}