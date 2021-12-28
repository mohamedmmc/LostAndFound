//
//  verificationCodeController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 19/12/2021.
//

import Foundation
import UIKit

class verificationCodeController: UIViewController {
    
    var code:String?
    var email:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
          view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBOutlet weak var codeTextfield: UITextField!
    
    @IBAction func retour(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Verifier(_ sender: Any) {
        print("le code que je rentre : ",codeTextfield.text!)
        print("le code que j'ai recu : ",self.code!)
        if (codeTextfield.text!.elementsEqual(self.code!)){
            performSegue(withIdentifier: "confirmationCode", sender: code)
        }
        else{
            self.propmt(title: "Erreur", message: "Code incorrect")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmationCode" {

            let destination = segue.destination as! ResetPassController

            destination.email = email!
            destination.code = self.code
        }

    }
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
