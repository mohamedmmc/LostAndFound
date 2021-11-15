//
//  CreateAccount.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 12/11/2021.
//

import Foundation
import UIKit



class CreateAccount: UIViewController {
    @IBOutlet weak var numT: UITextField!
    @IBOutlet weak var mdpT: UITextField!
    @IBOutlet weak var usernameT: UITextField!
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var valider: UIButton!
    let Design = DesignUi()
    override func viewDidLoad() {
        Design.BorderLabel(titre: titre, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 1))
        Design.BorderButton(titre: valider, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 2))
        let passord = UIImage(named: "password")
        let numphoto = UIImage(named: "phone")
        Design.addLeftIcon(txtField: numT, andImage: numphoto!)
        Design.addLeftIcon(txtField: mdpT, andImage: passord!)

    }
    @IBAction func validation(_ sender: UIButton) {
        let user = User(id:"",nom: nom.text!, prenom: prenom.text!, email: usernameT.text!, mdp: mdpT.text!, numtel: numT.text!, token: "")
        Webservice().creationCompte(user: user) { (succes,quotes) in
            if succes, let quotes = quotes{
                self.propmt(title: "saul goodman", message: quotes)
            }
            else{
                self.propmt(title: "Fuck", message: "here we go again")
            }
        }
        performSegue(withIdentifier: "otpsegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otpsegue" {
            
            let destination = segue.destination as! OTPController
            
            destination.numero = numT.text
        }
          
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
