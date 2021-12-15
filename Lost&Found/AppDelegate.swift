

// Swift
//
// AppDelegate.swift
import UIKit
import FBSDKCoreKit
import CoreData
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import SendBirdUIKit
import FBSDKLoginKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let APP_ID = "6FF6BD6D-A86D-47C0-BE32-22C7C6C8A337"  // Specify your Sendbird application ID.
        SBUMain.initialize(applicationId: APP_ID) {
            // DB migration has started.
        } completionHandler: { error in
            // If DB migration is successful, proceed to the next step.
            // If DB migration fails, an error exists.
        }
        // Case 1: USER_ID only
           

            // Case 2: Specify all fields
            
           
        let facebook = ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        if (facebook){
            return true
        }
        
//        UserDefaults.standard.removeObject(forKey: "_id")
//        UserDefaults.standard.removeObject(forKey: "tokenConnexion")
//        UserDefaults.standard.removeObject(forKey: "nom")
//        UserDefaults.standard.removeObject(forKey: "prenom")
//        UserDefaults.standard.removeObject(forKey: "numt")
//        UserDefaults.standard.removeObject(forKey: "email")
//        UserDefaults.standard.removeObject(forKey: "password")
//        UserDefaults.standard.removeObject(forKey: "photoProfil")
//        UserDefaults.standard.synchronize()
        GMSServices.provideAPIKey("AIzaSyCgv0EmuWrPqGsdcT1CJx-4HEGqiVfUGdg")
        GMSPlacesClient.provideAPIKey("AIzaSyCgv0EmuWrPqGsdcT1CJx-4HEGqiVfUGdg")
        let google = GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
        return false
       
    }
          
    func application(_ app: UIApplication, open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        
        var handled: Bool

          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }
          else{
            handled = ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
          }
        
        return false
    }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Lost_Found")
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
    
