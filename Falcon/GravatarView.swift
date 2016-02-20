//
//  Falcon
//
//  Created by Floran Pagliai on 20/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Haneke
import CryptoSwift

class GravatarView: UIView {
	
	var profilePhoto: UIImageView?
	
	var email: String? {
		didSet {
			getImage()
		}
	}
	
	var url: String? {
		didSet {
			getImageFromUrl()
		}
	}
	
	func setup() {
		let circleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		circleView.layer.cornerRadius = frame.width / 2;
		circleView.backgroundColor = UIColor.blackColor()
		addSubview(circleView)
		
		profilePhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
		profilePhoto?.layer.cornerRadius = frame.width / 2
		profilePhoto?.clipsToBounds = true
		profilePhoto?.image = UIImage(named: "hacker")
		addSubview(profilePhoto!)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	func getImage() {
		profilePhoto?.image = nil
		let url = NSURL(string: "http://www.gravatar.com/avatar/" + email!.md5() + ".jpg?s=400&d=404")
		profilePhoto?.hnk_setImageFromURL(url!)
	}
	
	func getImageFromUrl() {
		profilePhoto?.image = nil
		let nsurl = NSURL(string: url!)
		profilePhoto?.hnk_setImageFromURL(nsurl!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
}
