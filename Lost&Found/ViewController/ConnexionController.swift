//
//  ViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/11/2021.
//

import UIKit
import FBSDKLoginKit
class ViewController: UIViewController,LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        getUserDataFromFacebook()
        
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    @IBAction func loginButtonFB(_ sender: Any) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    let facebookLoginButton = FBLoginButton(frame: .zero, permissions: [.publicProfile,.email])
    
    func getUserDataFromFacebook() {
        GraphRequest(graphPath: "me", parameters: ["fields": "first_name,last_name, picture,email, id"]).start { (connection, result, error) in
            if let err = error { print(err.localizedDescription); return } else {
                if let fields = result as? [String:Any],let lastname = fields["last_name"] as? String,let firstName = fields["first_name"] as? String,let email = fields["email"] as? String, let id = fields["id"] as? String {
                    
                    let user = User(id: "", nom: lastname, prenom: firstName, email: email, mdp: "", numtel: "", photoP: "", token: "")
                    Webservice().loginSocialMedia(username: user.email) { succes, reponse in
                        if succes, let json = reponse as? String{
                            self.performSegue(withIdentifier: "connexion", sender: reponse)
                            if json == "pas inscrit" {
                                print("pas inscrit avec facebook")
                            }
                        }
                        else{
                            Webservice().CreationCompteFacebook(user: user, image: UIImage(named: "facebook")! ) { succes, reponse in
                                if succes, let json = reponse{
                                    self.performSegue(withIdentifier: "connexion", sender: reponse)
                                }
                                else if (reponse == "mail existant"){
                                    self.propmt(title: "Echec", message: "Mail deja Existant")
                                    
                                }
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    @IBOutlet weak var Connexin: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = AccessToken.current, !token.isExpired{
            performSegue(withIdentifier: "connexion", sender: "yes")            }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        facebookLoginButton.delegate = self
        facebookLoginButton.isHidden = true
        
        
        
        
        
        
        Connexin?.layer.cornerRadius = 10
        Connexin?.layer.borderWidth = 2
        Connexin?.layer.borderColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        username.layer.borderColor = UIColor.init(red: 146, green: 182, blue: 252, alpha: 0).cgColor
        username.layer.cornerRadius = 50
    }
    
    
    
    @IBAction func MdpOublie(_ sender: UIButton) {
        
    }
    @IBAction func Connexion(_ sender: UIButton) {
        let email = username.text!
        let pass = password.text!
        Webservice().login(username: email,mdp: pass) { (succes,reponse) in
            if succes, let json = reponse{
                
                self.performSegue(withIdentifier: "connexion", sender: nil)
            }
            else{
                self.propmt(title: "Echec", message: "Email ou mot de passe incorrect")
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



