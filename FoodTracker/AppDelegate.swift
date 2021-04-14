//
//  AppDelegate.swift: In charge of app life cycle
//  FoodTracker
//
//  Created by Fibiolla Plaath on 26/03/2021.
//

///Framework that construct & manage app's UI. Respond to user interactions & system evets. Enable accessibility. Fonts & images.
import UIKit

@main
/**
    #class AppDelegate
    Subclass of UIResponder & adopts protocol UIApplicationDelegate
      
    #UIResponder
     Having AppDelegate inherit from UIResponder allows it to interface with user actions.
 
    #UIApplicationDelegate
     Required & provides all functions needed to control the singleton UIApplication object.
 */
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    ///Called when new scene session is being creatd.
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    /// Called when user discards a scene session. If any sessions were discarded while app was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
        // Use this method to release any resources that were specific to discarded scenes, as they will not return.
    }
}



