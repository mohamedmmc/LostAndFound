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
                self.propmt(title: "Code", message: "Un mail contenant un code a ete envoye dans votre email")

            }
            else{
                self.propmt(title: "Erreur", message: "Mail inexistant !")
            }

        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func validerCodeButton(_ sender: Any) {
        if (codeTextfield.text!.elementsEqual(self.code)){
            performSegue(withIdentifier: "confirmationCode", sender: code)
        }
        else{
            self.propmt(title: "Erreur", message: "Code incorrect")
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
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
