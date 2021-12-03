//
//  AssociationsController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class AssociationsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logoutfb(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
}
