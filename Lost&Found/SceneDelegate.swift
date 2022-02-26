//
//  SceneDelegate.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/11/2021.
//

import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import SendBirdSDK
import SendBirdUIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        self.loadBaseController()
        

    
    }
    func loadBaseController() {
       let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       guard let window = self.window else { return }
       window.makeKeyAndVisible()
        if !( UserDefaults.standard.string(forKey: "_id") ?? "").isEmpty {
            SBUGlobals.CurrentUser = SBUUser(userId: UserDefaults.standard.string(forKey: "_id")!)
            let name = Notification.Name("articleAjoute")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            let homeVC: MySubclassedTabBarController = storyboard.instantiateViewController(withIdentifier: "connexion") as! MySubclassedTabBarController
                self.window?.rootViewController = homeVC
        }
        self.window?.makeKeyAndVisible()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
    }

}

