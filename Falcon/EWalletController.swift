//
//  EWalletController.swift
//  Falcon
//
//  Created by Floran Pagliai on 21/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import JDStatusBarNotification
import Firebase

class EWalletController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: Properties
	let walletManager = EWalletManager()
	var eWallet = [FalcoinAddress]()
	let ref = FirebaseManager()
	let userManager = UserManager()
	
	// MARK: View Properties
	@IBOutlet weak var falcoinAddresses: UITableView!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.falcoinAddresses.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
	}
	
	override func viewDidAppear(animated: Bool) {
		self.updateWallet()
		self.falcoinAddresses.reloadData()
	}
	
	// MARK: Actions
	@IBAction func addAddressAction(sender: UIBarButtonItem) {
		let falcoinAddress = FalcoinAddress()
		let falcoinAddressesRef = ref.getPathRef("falcoin_addresses")
		let addressKey = ref.childByAutoId(falcoinAddressesRef, data: falcoinAddress.toAnyObject())
		
		userManager.addAddress(addressKey)
		JDStatusBarNotification.showWithStatus("New Falcoin address created", dismissAfter: NSTimeInterval(5), styleName: JDStatusBarStyleSuccess)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.eWallet.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell:UITableViewCell = self.falcoinAddresses.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
		
		cell.textLabel?.text = self.eWallet[indexPath.row].privateKey
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			walletManager.removeAddress(self.eWallet[indexPath.row])
			self.eWallet.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}
	
	func updateWallet() {
		let userRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: ref.userRef)
		let walletRef = ref.getPathRef("wallet", ref: userRef)
		
		walletRef.observeEventType(.Value, withBlock: {
			(snapshot) in
			var newWallet = [FalcoinAddress]()
			let enumerator = snapshot.children
			while let children = enumerator.nextObject() as? FDataSnapshot {
				let falcoinAddrsRef = self.ref.getPathRef(children.value as! String, ref: self.ref.falcoinAddrsRef)
				falcoinAddrsRef.observeEventType(.Value, withBlock: {
					(snapshot) in
					let falcoinAddress = FalcoinAddress(snapshot: snapshot, userWalletRef: children.ref)
					newWallet.append(falcoinAddress)
					self.eWallet = newWallet
					self.falcoinAddresses.reloadData()
				})
			}
		})
	}
}