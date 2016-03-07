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
import UICountingLabel

class EWalletController: UIViewController, UITableViewDataSource {
	
	// MARK: Properties
	let walletManager = EWalletManager()
	var eWallet = Set<FalcoinAddress>()
	var originAddress: FalcoinAddress?
	let ref = FirebaseManager()
	let userManager = UserManager()
	
	// MARK: View Properties
	@IBOutlet weak var falcoinAddresses: UITableView!
	@IBOutlet weak var totalFalcoinsLabel: UICountingLabel!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.falcoinAddresses.rowHeight = 80.0
		self.totalFalcoinsLabel.format = "%d"
		self.totalFalcoinsLabel.method = UILabelCountingMethod.EaseOut
		self.falcoinAddresses.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.syncWallet()
	}
	
	override func viewDidAppear(animated: Bool) {
		
	}
	
	// MARK: Actions
	@IBAction func addAddressAction(sender: UIBarButtonItem) {
		if (self.eWallet.count < 5) {
			walletManager.newAdress()
			JDStatusBarNotification.showWithStatus("New Falcoin address created", dismissAfter: NSTimeInterval(5), styleName: JDStatusBarStyleSuccess)
		} else {
			JDStatusBarNotification.showWithStatus("You have too much Falcoin addresses", dismissAfter: NSTimeInterval(5), styleName: JDStatusBarStyleError)
		}
		
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "TransferFalcoin") {
			let navVC = segue.destinationViewController as! UINavigationController
			let svc = navVC.viewControllers.first as! TransferController
			
			svc.originAddress = self.originAddress
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.eWallet.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell:UITableViewCell = self.falcoinAddresses.dequeueReusableCellWithIdentifier("FalcoinAddressCell")! as UITableViewCell
		
		let address = self.eWallet[self.eWallet.startIndex.advancedBy(indexPath.row)]
		
		cell.textLabel?.text = "Public Address : " + String(address.publicKey)
		cell.detailTextLabel?.text = "Balance : " + String(address.balance) + " F"
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// the cells you would like the actions to appear needs to be editable
		return true
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			walletManager.removeAddress(self.eWallet[self.eWallet.startIndex.advancedBy(indexPath.row)])
			self.eWallet.remove(self.eWallet[self.eWallet.startIndex.advancedBy(indexPath.row)])
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
		let transfer = UITableViewRowAction(style: .Normal, title: "Transfer") { action, index in
			self.originAddress = self.eWallet[self.eWallet.startIndex.advancedBy(indexPath.row)]
			self.performSegueWithIdentifier("TransferFalcoin", sender: nil)
		}
		transfer.backgroundColor = UIColor.lightGrayColor()
		let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
			self.walletManager.removeAddress(self.eWallet[self.eWallet.startIndex.advancedBy(indexPath.row)])
			self.eWallet.remove(self.eWallet[self.eWallet.startIndex.advancedBy(indexPath.row)])
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
		delete.backgroundColor = UIColor.redColor()
		
		return [delete, transfer]
	}
	
	func syncWallet() {
		let userRef = ref.getPathRef((DataManager.sharedInstance.currentUser?.id)!, ref: ref.userRef)
		let walletRef = ref.getPathRef("wallet", ref: userRef)
		
		walletRef.observeEventType(.Value, withBlock: {
			(snapshot) in
			let enumerator = snapshot.children
			while let children = enumerator.nextObject() as? FDataSnapshot {
				let falcoinAddrsRef = self.ref.getPathRef(children.value as! String, ref: self.ref.falcoinAddrsRef)
				falcoinAddrsRef.observeEventType(.Value, withBlock: {
					(snapshot) in
					if snapshot.value is NSNull {
						// The value is null
					} else {
						let falcoinAddress = FalcoinAddress(snapshot: snapshot, userWalletRef: children.ref)
						
						self.eWallet.insert(falcoinAddress)
						self.calcTotal()
						self.falcoinAddresses.reloadData()
					}
				})
			}
		})
	}
	
	func calcTotal() {
		var total = 0
		for falcoinAddress in self.eWallet {
			  total += falcoinAddress.balance
		}
		self.totalFalcoinsLabel.countFromCurrentValueTo(CGFloat(total))
	}
}