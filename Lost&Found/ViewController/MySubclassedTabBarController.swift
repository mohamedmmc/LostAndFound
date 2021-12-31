//
//  MySubclassedTabBarController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 14/11/2021.
//

import Foundation
import UIKit
class MySubclassedTabBarController: UITabBarController {
    var test = 1
    override func viewDidLoad() {
      super.viewDidLoad()
      delegate = self
    }
}

 
extension MySubclassedTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
            
            let name = Notification.Name("articleAjoute")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            
            let name2 = Notification.Name("isVerified")
            let notificationVerified = Notification(name: name2)
            NotificationCenter.default.post(notificationVerified)
            
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
