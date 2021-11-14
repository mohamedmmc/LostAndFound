//
//  ViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/11/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Connexin: UIButton!
    private var userVM = UserModelView()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Connexin?.layer.cornerRadius = 10
        Connexin?.layer.borderWidth = 2
        Connexin?.layer.borderColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        username.layer.borderColor = UIColor.init(red: 146, green: 182, blue: 252, alpha: 0).cgColor
        username.layer.cornerRadius = 50
    }
    
    @IBAction func Connexion(_ sender: UIButton) {
        let email = username.text!
        let pass = password.text!
        UserModelView().login(username: email, mdp: pass)
    }
    

    @IBAction func CreateAccountB(_ sender: UIButton) {
        performSegue(withIdentifier: "test", sender: nil)
    }

    
}

