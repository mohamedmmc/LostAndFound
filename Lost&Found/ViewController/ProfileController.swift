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
        
    }
    @IBAction func ModifierProfil(_ sender: Any) {
        performSegue(withIdentifier: "modifierProfil", sender: "")
    }
    let webS = UserService()
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        if sender.isOn {
                    UIApplication.shared.windows.forEach{
                        window in window.overrideUserInterfaceStyle = .dark
                    }}else{
                        UIApplication.shared.windows.forEach{ window in window.overrideUserInterfaceStyle = .light
                    }
                    }
    }
    
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var Name: UILabel!
    
    
    
    
    func promptWithConfirm(){
        let refreshAlert = UIAlertController(title: "Deconnexion", message: "Etes vous sure de vouloir vous deconnecter ?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            let loginManager = LoginManager()
            loginManager.logOut()
            UserDefaults.standard.removeObject(forKey: "tokenConnexion")
            UserDefaults.standard.removeObject(forKey: "nom")
            UserDefaults.standard.removeObject(forKey: "prenom")
            UserDefaults.standard.removeObject(forKey: "numt")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "photoProfil")
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "deconnexion", sender: "ok")
            
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true) {
                
            }
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
  
}
