//
//  ViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/11/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func Connexion(_ sender: UIButton) {
    }
    

    @IBAction func CreateAccountB(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateAccount", sender: nil)
    }
}

