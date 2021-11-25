//
//  CreateAccount.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 12/11/2021.
//

import Foundation
import UIKit



class CreateAccount: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var numT: UITextField!
    @IBOutlet weak var mdpT: UITextField!
    @IBOutlet weak var usernameT: UITextField!
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var prenom: UITextField!
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var valider: UIButton!
    @IBOutlet weak var photoDeProfilImageView: UIImageView!
    
    
    
    let Design = DesignUi()
    override func viewDidLoad() {
        photoDeProfilImageView.contentMode = UIView.ContentMode.scaleAspectFit
        Design.BorderLabel(titre: titre, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 1))
        Design.BorderButton(titre: valider, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 2))
        let passord = UIImage(named: "password")
        let numphoto = UIImage(named: "phone")
        Design.addLeftIcon(txtField: numT, andImage: numphoto!)
        Design.addLeftIcon(txtField: mdpT, andImage: passord!)
        
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
    
    
    @IBAction func validation(_ sender: UIButton) {
        
        let user = User(id:"",nom: nom.text!, prenom: prenom.text!, email: usernameT.text!, mdp: mdpT.text!, numtel: numT.text!,photoP: "photo:"+usernameT.text! , token: "")
        
        //Webservice().creationCompte(user: user,userpdp: photoDeProfilImageView.image!)
        if isValidEmail(usernameT.text!){
            if (numT.text!.count != 8) {
                    UserService().CreationCompte(user: user, image: photoDeProfilImageView.image!) { (succes, reponse) in
                        if succes, let json = reponse{
                            print(json)
                            if (json == "ok"){
                                self.performSegue(withIdentifier: "connexion", sender: reponse)
                            }
                        }
                        else if (reponse == "mail existant"){
                            self.propmt(title: "Echec", message: "Mail deja Existant")
                            
                        }
                        else if (reponse == "num existant"){
                            self.propmt(title: "Echec", message: "Numero deja Existant")
                            
                            
                        }
                    }
                
            }else{
                self.propmt(title: "Echec", message: "Numero invalid")
            }

        }
        else{
            self.propmt(title: "Echec", message: "Email incorrect")
        }
        
        
        
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
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "otpsegue" {
    //
    //            let destination = segue.destination as! OTPController
    //
    //            destination.numero = numT.text
    //        }
    //
    //    }
    
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


