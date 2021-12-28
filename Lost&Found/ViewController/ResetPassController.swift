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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
          view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var code :String?
    var email : String?
    @IBAction func validerResetButton(_ sender: Any) {
        DispatchQueue.main.async {
            UserService().resetPass(password: self.password.text!, email: self.email!, code: self.code!) { succes, reponse in
                if succes{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "retour", sender: "okay")
                    }
                }
                else{
                    print("erreur reset pass")
                }
            }
        }
        
    }
    
    @IBOutlet weak var password: UITextField!
}
