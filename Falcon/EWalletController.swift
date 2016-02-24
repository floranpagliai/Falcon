//
//  EWalletController.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import JDStatusBarNotification

class EWalletController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: Properties
	let walletManager = EWalletManager()
	
	
	// MARK: View Properties
	@IBOutlet weak var falcoinAddresses: UITableView!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.walletManager.getWallet()
		self.falcoinAddresses.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.falcoinAddresses.reloadData()
	}
	
	override func viewDidAppear(animated: Bool) {
		walletManager.updateWalet()
		self.falcoinAddresses.reloadData()
	}
	
	// MARK: Actions
	@IBAction func addAddressAction(sender: UIBarButtonItem) {
		walletManager.newAdress()
		JDStatusBarNotification.showWithStatus("New Falcoin address created", dismissAfter: NSTimeInterval(5), styleName: JDStatusBarStyleSuccess)
		self.falcoinAddresses.reloadData()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DataManager.sharedInstance.eWallet.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell:UITableViewCell = self.falcoinAddresses.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
		
		cell.textLabel?.text = DataManager.sharedInstance.eWallet[indexPath.row].privateKey
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
}