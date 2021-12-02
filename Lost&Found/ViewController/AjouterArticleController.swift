//
//  AjouterArticle.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 26/11/2021.
//

import Foundation
import UIKit

class AjouterArticleController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let Design = DesignUi()
    var test = [Article]()
    var type = "Found"
    
    
    override func viewDidLoad() {
        NotificationCenter.default.post(name: Notification.Name("reloadTable"), object: nil)
        super.viewDidLoad()
        if typeArticleSwitch.isOn{
            type = "Found"
            labelTest.text = "Found"
        }else{
            type = "Lost"
            labelTest.text = "Lost"
        }
        Design.BorderButton(titre: ajouterButton, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 2))
    }
    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var typeArticleSwitch: UISwitch!
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var nomArticleTextfield: UITextField!
    @IBOutlet weak var descriptionArticleTextarea: UITextView!
    @IBOutlet weak var ajouterButton: UIButton!
    
    @IBAction func SwitchDidChange(_ sender: Any) {
        if typeArticleSwitch.isOn{
            type = "Found"
            labelTest.text = "Found"
        }else{
            type = "Lost"
            labelTest.text = "Lost"
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        imageArticle.image = image
        
        dismiss(animated: true)
    }
    @IBAction func parcourir(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func Ajouter(_ sender: Any) {
        if (!nomArticleTextfield.text!.isEmpty){
            let user = User(id: UserDefaults.standard.string(forKey: "_id")!, nom: "", prenom: "", email: "", mdp: "", numtel: "", photoProfil: "", isVerified: false, __v: 0)
            print("l'utilisateur bouton ajoute article ", user)
            let article = Article(_id: "", nom: nomArticleTextfield.text!, description: descriptionArticleTextarea.text!, addresse: "1", photo: "2", dateCreation: "3", dateModif: "4",type: type, user: user,__v: 0)
            ArticleService().AjoutArticle(article: article, image: imageArticle.image!) { succes, reponse in
                if succes, let json = reponse{

                    let name = Notification.Name("articleAjoute")
                    let notification = Notification(name: name)
                    NotificationCenter.default.post(notification)
                    self.dismiss(animated: true, completion: nil)
                    
                }

        }
        }
            else{
                self.propmt(title: "Erreur d'ajout", message: "Impossible d'ajouter")
            }
        
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
