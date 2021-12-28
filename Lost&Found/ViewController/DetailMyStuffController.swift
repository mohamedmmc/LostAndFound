//
//  DetailMyStuffController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 19/12/2021.
//

import Foundation
import UIKit

class DetailMyStuffController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var type = "Found"
    let Design = DesignUi()
    var test : Article?
    var gpsLocation = [Double]()
    @IBOutlet weak var ajouterButton: UIButton!
    @IBOutlet weak var imageMyStuff: UIImageView!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var lostFoundUiSwitch: UISwitch!
    @IBOutlet weak var nomTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageMyStuff.imageFromServerURL(urlString: (test?.photo)!)
        textArea.text = test?.description
        nomTextfield.text = test?.nom
        if test?.type == "Lost" {
            lostFoundUiSwitch.isOn = false
        }else{
            lostFoundUiSwitch.isOn = true
        }
        Design.BorderButton(titre: ajouterButton, radius: 20, width: 2, Bordercolor: UIColor.init(red: 255, green: 255, blue: 255, alpha: 2))
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
          view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func switchLostFound(_ sender: Any) {
        if lostFoundUiSwitch.isOn{
            type = "Found"
        }else{
            type = "Lost"
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        imageMyStuff.image = image
        
        dismiss(animated: true)
    }
   
    @IBAction func Parcourir(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
   
    @IBAction func getMap(_ sender: Any) {
        performSegue(withIdentifier: "gpsSegue", sender: nil)
    }
    @IBAction func ModifierButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Un instant...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        let articleModifier = Article(_id: test!._id, nom: nomTextfield.text, description: textArea.text, addresse: test?.addresse, photo: "", dateCreation: test!.dateCreation, dateModif: test!.dateModif, type: type, user: test!.user, __v: 0)
        ArticleService().modifierArticle(article: articleModifier, image: imageMyStuff.image!) { succes, reponseArticle in
            if succes{
                let name = Notification.Name("updateArticle")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                alert.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                self.propmt(title: "Succes", message: "Modifé avec succes !")
                }
            }else{
                alert.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.propmt(title: "Erreur", message: "Probleme de connexion")
                }
            }
        }
    }
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
