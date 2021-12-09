//
//  OTPController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class MotDePasseOublieController: UIViewController {
    var code = ""
    @IBAction func validerButton(_ sender: Any) {
        UserService().forgotPassword(email: emailConcerne.text!) { success, reponse in
            if success{
                self.code = reponse! as! String
            }

        }
    }
    @IBAction func validerCodeButton(_ sender: Any) {
        if (codeTextfield.text!.elementsEqual(self.code)){
            performSegue(withIdentifier: "confirmationCode", sender: code)
        }
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "confirmationCode" {
    
                let destination = segue.destination as! ResetPassController
    
                destination.email = emailConcerne.text!
                destination.code = self.code
            }
    
        }
    @IBOutlet weak var codeTextfield: UITextField!
    @IBOutlet weak var emailConcerne: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
