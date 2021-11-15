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

        performSegue(withIdentifier: "otpsegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otpsegue" {
            
            let destination = segue.destination as! OTPController
            destination.numero = numT.text
        }
          
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
