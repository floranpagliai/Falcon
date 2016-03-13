//
//  PersmissionManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 18/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import PermissionScope

class PersmissionManager {
	
	static func showPermisionDialog(withCompletionBlock: (error: Bool) -> Void) {
		let pscope = PermissionScope(backgroundTapCancels: false)
		
		pscope.headerLabel.text = "Hey !"
		pscope.addPermission(LocationWhileInUsePermission(), message: "We use this to track\r\nwhere you live")
		
		pscope.closeButton = UIButton()
		pscope.show({
			finished, results in
			  withCompletionBlock(error: false)
			},
			cancelled: {
				(results) -> Void in
				withCompletionBlock(error: true)
		})
	}
}