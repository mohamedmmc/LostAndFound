//
//  ViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/11/2021.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import SendBirdUIKit
class ViewController: UIViewController,LoginButtonDelegate {
    
    var faza = UIImage(named: "")

    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        getUserDataFromFacebook()
    }
    @IBAction func loginGoogleButton(_ sender: Any) {
        getUserDataFromGoogle()
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
    func getUserDataFromGoogle (){
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
        let signInConfig = GIDConfiguration.init(clientID: "226296852735-1vvlur0mo1hm96ppbvn88qmq14odbjlt.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [self] userG, error in
          guard error == nil else { return }
         var nom = ""
           // print(user?.profile?.imageURL(withDimension: 512))
            if !(userG?.profile?.familyName ?? "").isEmpty{
                nom = (userG?.profile?.familyName)!
            }
            let user = User(id: "", nom: nom, prenom: (userG?.profile?.givenName)!, email: (userG?.profile!.email)!, mdp: "", numtel: "", photoProfil: "",isVerified: false,__v: 0)

           if let dataPhoto = try? Data(contentsOf: (userG?.profile?.imageURL(withDimension: 512))!) {
                 faza = UIImage(data: dataPhoto)
            
            }
            UserService().loginSocialMedia(username: user.email) { succes, reponse in
                if succes, let json = reponse as? String{
                    alert.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "connexion", sender: reponse)
                    if json == "pas inscrit" {
                        print("pas inscrit avec facebook")
                    }
                }
                else{
                    UserService().CreationCompteSocial(user: user, image: faza! ) { succes, reponse in
                        if succes, let json = reponse{
                            if (json as! String == "ok"){
                                alert.dismiss(animated: true, completion: nil)
                                SendBirdApi().SendBirdCreateAccount(user_id: UserDefaults.standard.string(forKey: "_id")!, nickname:  UserDefaults.standard.string(forKey: "nom")!, profile_url:  UserDefaults.standard.string(forKey: "photoProfil")!)
                                self.performSegue(withIdentifier: "connexion", sender: reponse)
                            }
                        }
                        else if (reponse as! String == "mail existant"){
                            alert.dismiss(animated: true, completion: nil)
                            self.propmt(title: "Echec", message: "Mail deja Existant")
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func loginButtonFB(_ sender: Any) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    let facebookLoginButton = FBLoginButton(frame: .zero, permissions: [.publicProfile,.email])
    
    func getUserDataFromFacebook() {
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
        let imageData = NSData()
        GraphRequest(graphPath: "me", parameters: ["fields": "first_name,last_name,  picture.width(480).height(480),email, id"]).start { [self] (connection, result, error) in
                if let fields = result as? [String:Any],let lastname = fields["last_name"] as? String,let firstName = fields["first_name"] as? String,let email = fields["email"] as? String, let id = fields["id"] as? String {
                    if let profilePictureObj = fields["picture"] as? NSDictionary{
                        let data = profilePictureObj["data"] as! NSDictionary
                        let pictureUrlString  = data["url"] as! String
                        let pictureUrl = NSURL(string: pictureUrlString)
                        let imageData = NSData(contentsOf: pictureUrl! as URL)
                        faza = UIImage(data: imageData as! Data)
                    }
                    
                    let user = User(id: "", nom: lastname, prenom: firstName, email: email, mdp: "", numtel: "", photoProfil: "", isVerified: false,__v: 0)
                    UserService().loginSocialMedia(username: user.email) { succes, reponse in
                        if succes, let json = reponse as? String{
                            alert.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "connexion", sender: reponse)
                            if json == "pas inscrit" {
                                print("pas inscrit avec facebook")
                            }
                        }
                        else{
                            UserService().CreationCompteSocial(user: user, image: faza! ) { succes, reponse in
                                if succes, let json = reponse{
                                    alert.dismiss(animated: true, completion: nil)
                                    SendBirdApi().SendBirdCreateAccount(user_id: UserDefaults.standard.string(forKey: "_id")!, nickname:  UserDefaults.standard.string(forKey: "nom")!, profile_url:  UserDefaults.standard.string(forKey: "photoProfil")!)
                                    self.performSegue(withIdentifier: "connexion", sender: reponse)
                                }
                                else if (reponse! == "mail existant"){
                                    alert.dismiss(animated: true, completion: nil)
                                    self.propmt(title: "Echec", message: "Mail deja Existant")
                                }
                            }
                        }
                    }
                }
            }
        alert.dismiss(animated: true, completion: nil)
        }
    
    @IBOutlet weak var Connexin: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        if let token = AccessToken.current, !token.isExpired{
            performSegue(withIdentifier: "connexion", sender: "yes")
        }
        
        //print(UserDefaults.standard.dictionaryRepresentation())

       

        
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
            if succes, let json = reponse{
                alert.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: "connexion", sender: nil)
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



