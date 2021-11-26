//
//  AjouterArticle.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 26/11/2021.
//

import Foundation
import UIKit

class AjouterArticle: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let Design = DesignUi()
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.BorderButton(titre: ajouterButton, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 2))
    }
    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var typeArticleSwitch: UISwitch!
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var nomArticleTextfield: UITextField!
    @IBOutlet weak var descriptionArticleTextarea: UITextView!
    @IBOutlet weak var ajouterButton: UIButton!

    
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
            let article = Article(_id: "", nom: nomArticleTextfield.text!, description: descriptionArticleTextarea.text!, addresse: "1", photo: "2", dateCreation: "3", dateModif: "4",type: "5",__v: 0)
            ArticleService().AjoutArticle(article: article, image: imageArticle.image!) { succes, reponse in
                if succes, let json = reponse{
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
