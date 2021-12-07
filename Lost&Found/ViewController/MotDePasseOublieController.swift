//
//  OTPController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class MotDePasseOublieController: UIViewController {

    @IBAction func validerButton(_ sender: Any) {
        UserService().forgotPassword(email: emailConcerne.text!) { success, reponse in
            if success{
                print("normalement jawwna behi")
            }
            else{
                
            }
        }
    }
    @IBOutlet weak var emailConcerne: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
