//
//  DetailArticleController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 27/11/2021.
//

import Foundation
import UIKit
import GoogleMaps
class DetailArticleController: UIViewController {
    
    @IBOutlet weak var signalerButton: UIButton!
    @IBOutlet weak var supprimerAdminButton: UIButton!
    @IBOutlet weak var testGps: GMSMapView!
    @IBOutlet weak var repondreQuestion: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if article!.user._id == UserDefaults.standard.string(forKey: "_id") {
            articleSameUserLabel.text = "C'est votre article"
            contactButtonn.isHidden = true
            repondreQuestion.isHidden = true
        }
        if (article?.question?._id ?? "").isEmpty{
            repondreQuestion.isHidden = true
        }
        else{
            contactButtonn.isHidden = true
        }
        if UserDefaults.standard.string(forKey: "email")! == "chicco631@gmail.com" {
            signalerButton.isHidden = true
        }else{
            supprimerAdminButton.isHidden = true
        }
        articleImageView.imageFromServerURL(urlString: article!.photo!)
        nomArticleLabel.text = article!.nom
        descriptionArticleLabel.text = article!.description!
        if !(article?.addresse ?? []).isEmpty{
            
            let camera = GMSCameraPosition.camera(withLatitude: (article?.addresse![0])!, longitude: (article?.addresse![1])!, zoom: 15)
            testGps.camera = camera
            let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:  (article?.addresse![0])!, longitude: (article?.addresse![1])!)
                    marker.title = "Sydney"
                    marker.snippet = "Australia"
                    marker.map = testGps
        }
        else{
            testGps.isHidden = true
        }
        
    }
    @IBAction func deleteAdmin(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Confrimer", message: "Etes vous sure de vouloir supprimer cet article?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            ArticleService().deleteArticle(id: self.article!._id)
            let name = Notification.Name("articleAjoute")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            self.navigationController?.popToRootViewController(animated: true)

        }))
        refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true) {
            }
        }))
        present(refreshAlert, animated: true, completion: nil)

    }
        
    
    
    @IBAction func ReportButton(_ sender: Any) {

        UserService().Report(user: UserDefaults.standard.string(forKey: "_id")!, article: article!._id) { succes, reponse in
        if succes{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let name = Notification.Name("articleAjoute")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                self.dismiss(animated: true, completion: nil)
                self.propmt(title: "Signaler", message: "Signaler avec succes !")
            }
        }else{
            if reponse == "same user" {
                self.propmt(title: "Deja signalé", message: "Vous avez deja signalé cet article")
            }else if reponse == "spam"{
                self.propmt(title: "Suppression en cours", message: "L'article a recu assez de vote pour etre supprime")

            }
            }
        }
        
                
    }
    
    var article :Article?
    var nom ,desc,image:String?

    @IBAction func repondreQuestion(_ sender: Any) {
        let alertController = UIAlertController(title: "Repondez a la Question", message: "Repondez a la question suivante pour contacter l'utilisateur : "+article!.question!.titre!, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Reponse"
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Repondre", style: .default) { [self] _ in
            let questionEcrite = alertController.textFields![0].text
            QuestionReponseService().ReponseQuestion(reponse: questionEcrite!, idQuestion: (article!.question?._id)!) { succes, reponse in
                if succes{
                    alertController.dismiss(animated: true, completion: nil)
                    repondreQuestion.isHidden = true
                    //contactButtonn.isHidden = false
                }else{
                    if reponse as? String == "existe" {
                        self.propmt(title: "Vous avez deja repondu !", message: "Vous avez deja repondu a la question, veuillez attendre la reponse de " + (article?.user.nom)!)
                    }
                    else{
                        self.propmt(title: "Echec !", message: "Oups")
                    }
                }
            }

        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var contactButtonn: UIButton!
    @IBOutlet weak var nomArticleLabel: UILabel!
    @IBOutlet weak var descriptionArticleLabel: UITextView!
    @IBOutlet weak var articleSameUserLabel: UILabel!
    
    
    @IBAction func contactButton(_ sender: Any) {
        performSegue(withIdentifier: "contactProfil", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactProfil" {
            let destination = segue.destination as! ConstactProfilController
            destination.user = article?.user
        }
    }
    
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
