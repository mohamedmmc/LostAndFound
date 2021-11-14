//
//  OTPController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class OTPController: UIViewController {

    var numero:String?
    let Design = DesignUi()
    @IBOutlet weak var Verifier: UIButton!
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var numT: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailimg = UIImage(named: "password")
        Design.BorderButton(titre: Verifier, radius: 20, width: 1, Bordercolor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        Design.addLeftIcon(txtField: numT, andImage: emailimg!)
        
        
        
    }
}
