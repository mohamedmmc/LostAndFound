//
//  ProfileController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit
class ProfileController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let test = UserDefaults.standard.string(forKey: "nom")

        profilPic.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "photoProfil")!)

        Name.text = test
    }
    
    @IBAction func deconnexion(_ sender: Any) {
        promptWithConfirm()
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    let webS = Webservice()
   
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var Name: UILabel!
    
    
    func promptWithConfirm(){
        let refreshAlert = UIAlertController(title: "Deconnexion", message: "Etes vous sure de vouloir vous deconnecter ?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "deconnexion", sender: "ok")
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true) {
                
            }
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
  
}
