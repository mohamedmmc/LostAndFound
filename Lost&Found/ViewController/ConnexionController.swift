//
//  ViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/11/2021.
//

import UIKit
import GoogleMaps
import SendBirdUIKit
import AuthenticationServices
class ViewController: UIViewController  {
    
   

    
    
   
    var faza = UIImage(named: "")

    
//    @IBAction func appleButtonTap(_ sender: Any) {
//
//        let provider = ASAuthorizationAppleIDProvider()
//            let request = provider.createRequest()
//            request.requestedScopes = [.fullName,.email]
//            let controller =  ASAuthorizationController(authorizationRequests: [request])
//            controller.delegate = self
//            controller.presentationContextProvider = self
//            controller.performRequests()
//
//
//    }


    
    
   
    
    @IBOutlet weak var Connexin: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
  
    
  
    override func viewDidLoad() {

        
        super.viewDidLoad()
        DesignUi().getTheme()

        Connexin?.layer.cornerRadius = 10
        Connexin?.layer.borderWidth = 2
        Connexin?.layer.borderColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        username.layer.borderColor = UIColor.init(red: 146, green: 182, blue: 252, alpha: 0).cgColor
        username.layer.cornerRadius = 50
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

          //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
          //tap.cancelsTouchesInView = false

          view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func MdpOublie(_ sender: UIButton) {
        performSegue(withIdentifier: "mdpOublie", sender: nil)
        
    }
    @IBAction func Connexion(_ sender: UIButton) {
        let email = username.text!
        let pass = password.text!
        let alert = UIAlertController(title: nil, message: "Un instant...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        }))
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        UserService().login(username: email,mdp: pass) { (succes,reponse) in
            if succes{
                alert.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "connexion", sender: nil)
                }
            }
            else if (reponse  == "no connexion"){
                alert.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                self.propmt(title: "Echec", message: "Probleme de connexion")
                }
            }
            else{
                alert.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                    self.propmt(title: "Echec", message: "Email ou mot de passe incorrect")}
            }
        }
    }
    
    func testSegue(_ identifier: String!, sender:AnyObject!){
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    @IBAction func CreateAccountB(_ sender: UIButton) {
        performSegue(withIdentifier: "test", sender: nil)
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}




