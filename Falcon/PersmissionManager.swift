//
//  PersmissionManager.swift
//  Falcon
//
//  Created by Floran Pagliai on 18/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import PermissionScope

class PersmissionManager {
	
	static func showPermisionDialog() {
		let pscope = PermissionScope()
		
		pscope.addPermission(LocationWhileInUsePermission(), message: "We use this to track\r\nwhere you live")

		pscope.show()
	}
}