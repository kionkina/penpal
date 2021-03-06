//
//  AppDelegate.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDynamicLinks
import FirebaseCore
import FirebaseFirestore

typealias FIRUser = FirebaseAuth.User

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        TranslationManager.shared.fetchSupportedLanguages { (fetchedLanguages) in
            fetchedLanguages ? print("Languages have been fetched!") : print("Languages could not be fetched...")
        }
        LocationManager.shared.getCountriesandStates()
        

        configureInitialRootViewController(for: window)
        return true
    }

}


extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController

        if Auth.auth().currentUser?.uid != nil,
            let userData = defaults.object(forKey: "currentUser") as? Data,
            //let user = try? NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: userData as! Data ) {
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
      
            User.setCurrent(user)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            initialViewController = storyboard.instantiateViewController(withIdentifier: "tabController")
        }
        else {
            print("in else")
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            // Look into using UINavigationController
            initialViewController = storyboard.instantiateViewController(withIdentifier:"LoginViewController")
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
