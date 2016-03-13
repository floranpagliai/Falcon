//
//  TransferController.swift
//  Falcon
//
//  Created by Floran Pagliai on 03/03/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import JDStatusBarNotification
import Firebase
import UICountingLabel

class TransferController: UIViewController {
	
	// MARK: Properties
	let walletManager = EWalletManager()
	var originAddress: FalcoinAddress?
	var destAddress: FalcoinAddress?
	
	@IBOutlet weak var desAddressTextField: UITextField!
	@IBOutlet weak var originAddressLabel: UICountingLabel!
	@IBOutlet weak var destAddressLabel: UICountingLabel!
	@IBOutlet weak var amountTextField: UITextField!
	@IBOutlet weak var transferButton: UIButton!
	
	// MARK: UIViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.desAddressTextField.keyboardType = UIKeyboardType.DecimalPad
		self.amountTextField.keyboardType = UIKeyboardType.DecimalPad
		self.originAddressLabel.format = "%d";
		self.destAddressLabel.format = "%d";
		self.originAddressLabel.method = UILabelCountingMethod.EaseOut
		self.destAddressLabel.method = UILabelCountingMethod.EaseOut
		self.originAddressLabel.text = String(self.originAddress!.balance)
	}
	
	override func viewDidAppear(animated: Bool) {
		
	}
	
	@IBAction func searchDestAddress(sender: AnyObject) {
		self.walletManager.get(self.desAddressTextField.text!) {
			(error, falcoinAddress) -> Void in
			if (!error) {
				self.destAddress = falcoinAddress
				self.destAddressLabel.countFrom(CGFloat(self.destAddress!.balance), to: CGFloat(self.destAddress!.balance))
			} else {
				self.destAddress = nil
				self.destAddressLabel.countFrom(CGFloat(0), to: CGFloat(0))
			}
		}
	}
	
	@IBAction func amountCheckAction(sender: UITextField) {
		self.checkAmount()
	}
	
	@IBAction func transferAction(sender: UIButton) {
		self.amountTextField.enabled = false
		self.walletManager.transfer(&self.originAddress!, destAddress: &self.destAddress!, amount: Int(self.amountTextField.text!)!)
		self.checkAmount()
		self.originAddressLabel.countFromCurrentValueTo(CGFloat((self.originAddress?.balance)!))
		self.destAddressLabel.countFromCurrentValueTo(CGFloat((self.destAddress?.balance)!))
		self.amountTextField.enabled = true
	}
	
	@IBAction func closeActon(sender: UIBarButtonItem) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func checkAmount() {
		if (self.amountTextField.text != "" && self.originAddress?.balance >= Int(self.amountTextField.text!) && Int(self.amountTextField.text!) > 0 && self.destAddress != nil) {
			self.transferButton.enabled = true
		} else {
			self.transferButton.enabled = false
		}
	}
	
	/**
	* Called when the user click on the view (outside the UITextField).
	*/
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
}