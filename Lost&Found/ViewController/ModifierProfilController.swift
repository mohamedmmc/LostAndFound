//
//  ModifierProfilController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 22/11/2021.
//

import Foundation
import UIKit

class ModiferProfilController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let Design = DesignUi()

    override func viewDidLoad() {
        numT.text = UserDefaults.standard.string(forKey: "numt")
        usernameT.text = UserDefaults.standard.string(forKey: "email")
        nom.text = UserDefaults.standard.string(forKey: "nom")
        prenom.text = UserDefaults.standard.string(forKey: "prenom")
        if (UserDefaults.standard.string(forKey: "numt") != nil ){
            numT.text = UserDefaults.standard.string(forKey: "numt")
        }
        super.viewDidLoad()
        photoDeProfilImageView.contentMode = UIView.ContentMode.scaleAspectFit
        Design.BorderButton(titre: valider, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 2))
        photoDeProfilImageView.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "photoProfil")!)
    }
    
    
    @IBOutlet weak var valider: UIButton!
    @IBOutlet weak var numT: UITextField!
    @IBOutlet weak var usernameT: UITextField!
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var photoDeProfilImageView: UIImageView!
    
    
    
    @IBAction func valider(_ sender: Any) {
 
        if isValidEmail(usernameT.text!){
            if (numT.text!.count != 8){
                let user = User(id: UserDefaults.standard.string(forKey: "_id")!, nom: nom.text!, prenom: prenom.text!, email: usernameT.text!, mdp: UserDefaults.standard.string(forKey: "password")!, numtel: numT.text!, photoP: UserDefaults.standard.string(forKey: "photoProfil")!, token: UserDefaults.standard.string(forKey: "tokenConnexion")!)
                let pictureUrl = NSURL(string: UserDefaults.standard.string(forKey: "photoProfil")!)
              
                let imageData = NSData(contentsOf: pictureUrl! as URL)
                let faza = UIImage(data: imageData as! Data)
                    UserService().UpdateProfil(user: user, image: faza!) { succes, reponse in
                        if succes, let json = reponse{
                            print(json)
                            self.dismiss(animated: true)
                        }
                        else{
                            print(reponse)
                        }
                    }
                }
        }
    }
    
    
    @IBAction func Parcourir(_ sender: Any) {
    let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        photoDeProfilImageView.image = image
        
        dismiss(animated: true)
    }
    
    func isValidNumber ( mobilePhone:String) ->Bool{
        if (mobilePhone.count != 8){
            return false
        }
        return true
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
