//
//  OTPController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class MotDePasseOublieController: UIViewController {
    var code = "random"
     
    @IBAction func validerButton(_ sender: Any) {
        UserService().forgotPassword(email: emailConcerne.text!) { success, reponse in
            if success{
                self.code = reponse! as! String
                self.performSegue(withIdentifier: "codeVerification", sender: self.code)

            }
            else{
                self.propmt(title: "Erreur", message: "Mail inexistant !")
            }

        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "codeVerification" {
    
                let destination = segue.destination as! verificationCodeController
    
                destination.email = emailConcerne.text!
                destination.code = self.code
            }
    
        }
    @IBOutlet weak var emailConcerne: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

          view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
