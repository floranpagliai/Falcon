//
//  AppDelegate.swift
//  Falcon
//
//  Created by Floran Pagliai on 07/02/2016.
//  Copyright © 2016 Falcon. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var ref: Firebase!

	override init() {
		super.init()
		Firebase.defaultConfig().persistenceEnabled = true
	}

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		var controllerId = "Login";
		let ref = Firebase(url: "https://falcongame.firebaseio.com")
		GMSServices.provideAPIKey("AIzaSyDg64M-wm_BOaiicA5nt0f3zqGPWbNFfvs")

		if ref.authData != nil {
			controllerId = "Home";
		} else {
			controllerId = "Login";
		}
		
		let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let initViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier(controllerId) as UIViewController
		self.window?.rootViewController = initViewController
		
		return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		FBSDKAppEvents.activateApp()
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
			return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
	}


}

