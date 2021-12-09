//
//  ResetPassController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 07/12/2021.
//

import Foundation
import UIKit

class ResetPassController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var code :String?
    var email : String?
    @IBAction func validerResetButton(_ sender: Any) {
        UserService().resetPass(password: password.text!, email: email!, code: code!) { succes, reponse in
            if succes{
                self.performSegue(withIdentifier: "retour", sender: "nil")
            }
            else{
                print("erreur reset pass")
            }
        }
    }
    
    @IBOutlet weak var password: UITextField!
}
