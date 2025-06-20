//
//  AppDelegate.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 4/12/21.
//
//  Email : nfrancal@usc.edu

import UIKit
// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios
import GoogleSignIn
// Google Maps API and Google Places APIs provided by: https://developers.google.com/maps/documentation/ios-sdk/start
import GoogleMaps
import GooglePlaces
import CoreData


// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // initialize Google sign-in client ID
        GIDSignIn.sharedInstance().clientID = "1026867536240-vi3dv664um146iuie794js501venjhe6.apps.googleusercontent.com"
        
        // API Keys for Google Maps Services and Google Places Client
        GMSServices.provideAPIKey("AIzaSyCqPGUH-JHq_VaxylvpG5EfeegqJ0N0BNM")
        GMSPlacesClient.provideAPIKey("AIzaSyCqPGUH-JHq_VaxylvpG5EfeegqJ0N0BNM")
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        // returns the Google Sign-In handler
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // so that it can run on iOS 8 or later
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // returns the Google Sign-In handler
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        var _ = NSEntityDescription.insertNewObject(forEntityName: "Listing", into: context) as! Listing
        // var _ = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context) as! Listing
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

