//
//  ProfileController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit
import DropDown
import MapKit
import SendBirdSDK
import SendBirdUIKit
import LocalAuthentication

class ProfileController: UIViewController {
    var darkTheme = false
    let dropDown = DropDown()
  
    let Design = DesignUi()
    let myStuffTableau = [Article]()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var settingsUIbutton: UIBarButtonItem!
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var verifierbuttonState: UIButton!
    @IBAction func settingsUibuttonTapped(_ sender: Any) {
        dropDown.show()
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "myStuff" {
    
                let destination = segue.destination as! MyStuff
    
                destination.tableauMyStuff = myStuffTableau
            }
    
        }
    
    
    @IBAction func questionArticleButton(_ sender: Any) {
        ArticleService().getArticleByUser(id: UserDefaults.standard.string(forKey: "_id")!) { succes, articles in
            if (articles?.articles!.count)! > 0{
                for question in articles!.articles! {
                    print(question.question?.article)
                }
            }
        }
    }
    
    
    @IBAction func MyStuff(_ sender: Any) {
        ArticleService().getArticleByUser(id: UserDefaults.standard.string(forKey: "_id")!) { succes, articles in
            if succes{
                print(articles)
            if (articles?.articles!.count)! > 0{
                let name = Notification.Name("MyStuffAdded")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                self.performSegue(withIdentifier: "myStuff", sender: self.myStuffTableau)
            }
            else{
                self.propmt(title: "Vous n'avez rien ajouté pour le moment", message: "Essayez d'ajouter un article avant de voir")
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
    override func viewDidLoad() {
        
        let name2 = Notification.Name("isVerified")
        let notificationVerified = Notification(name: name2)
        NotificationCenter.default.post(notificationVerified)
        super.viewDidLoad()
       
        dropDown.anchorView = settingsUIbutton // UIView or UIBarButtonItem
        dropDownSelector()
        dropDown.dataSource = ["Securite","Modifier Profil","Theme","Déconnexion","Supprimer Profil"]
        dropDown.selectionBackgroundColor = .blue

        profileUpdated()
        profilPic.contentMode = UIView.ContentMode.scaleAspectFit
        
        Design.RadiusImage(titre: profilPic!, radius: 5,width: 2,Bordercolor: .white)
        
        let name = Notification.Name("updateProfil")
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: name, object: nil)
        
        
        
        let name3 = Notification.Name("isVerified")
        NotificationCenter.default.addObserver(self, selector: #selector(verifiedUpdated), name: name3, object: nil)
        
        
        if (UserDefaults.standard.bool(forKey: "isVerified")){
            verifierbuttonState.isHidden = true
        }
        else{
            verifierbuttonState.isHidden = false
        }
        
    }
    func dropDownSelector (){
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if (item == "Modifier Profil"){
                performSegue(withIdentifier: "modifierProfil", sender: nil)
            }
            else if (item == "Theme"){
                let refreshAlert = UIAlertController(title: "Changer theme", message: "Etes vous sure de vouloir changer de theme ?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    if traitCollection.userInterfaceStyle == .light {
                        UIApplication.shared.windows.forEach { window in
                            window.overrideUserInterfaceStyle = .dark
                            SBUTheme.set(theme: .dark)
                            darkTheme = true
                            UIColor.white
                        }
                    }
                    else{
                        UIApplication.shared.windows.forEach { window in
                            window.overrideUserInterfaceStyle = .light
                            SBUTheme.set(theme: .light)
                            
                        }
                    }
                }))
                refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
                    refreshAlert.dismiss(animated: true) {
                    }
                }))
                present(refreshAlert, animated: true, completion: nil)

            }
            else if (item == "Déconnexion"){
                promptWithConfirm()
            }
            else if (item == "Supprimer Profil"){
                let refreshAlert = UIAlertController(title: "Supprimer", message: "Etes vous sure de vouloir supprimer votre profile ?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
                    let context = LAContext()
                    var error: NSError?

                    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                        let reason = "Identify yourself!"

                        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                            [weak self] success, authenticationError in

                            DispatchQueue.main.async {
                                if success {
                                    UserService().deleteProfil { succes, reponse in
                                        if succes{
                                            UserDefaults.standard.removeObject(forKey: "apple")
                                            SendBirdApi().deleteUser(id: UserDefaults.standard.string(forKey: "_id")!)
                                            let alert = UIAlertController(title: nil, message: "Un instant...", preferredStyle: .alert)
                                            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                                            loadingIndicator.hidesWhenStopped = true
                                            loadingIndicator.style = UIActivityIndicatorView.Style.gray
                                            loadingIndicator.startAnimating();
                                            alert.view.addSubview(loadingIndicator)
                                            present(alert, animated: true, completion: nil)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                
                                                self!.clearData()
                                                alert.dismiss(animated: true, completion: nil)
                                                self!.performSegue(withIdentifier: "deconnexion", sender: "ok")
                                            }
                                        }
                                    }
                                } else {
                                    let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                                    self!.present(ac, animated: true)                                }
                            }
                        }
                    } else {
                        let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)                    }
                   
                }))
                refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
                    refreshAlert.dismiss(animated: true) {
                    }
                }))
                present(refreshAlert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func verifyButton(_ sender: Any) {
        UserService().resendConfirmationAccount(email: UserDefaults.standard.string(forKey: "email")!, id: UserDefaults.standard.string(forKey: "_id")!) { succes, reponse in
            if succes{
                print(reponse)
            }
            else{
                print(reponse)
            }
        }
    }
    
    
    func clearData(){
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.removeObject(forKey: "_id")
        UserDefaults.standard.removeObject(forKey: "tokenConnexion")
        UserDefaults.standard.removeObject(forKey: "nom")
        UserDefaults.standard.removeObject(forKey: "prenom")
        UserDefaults.standard.removeObject(forKey: "numt")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "photoProfil")
        UserDefaults.standard.synchronize()
    }
    
    @objc func verifiedUpdated(){
        UserService().getVerifiedUser { [self] succes in
            if succes{
                verifierbuttonState.isHidden = true

            }
            else{
                verifierbuttonState.isHidden = false
            }
        }

    }

    
    @objc func profileUpdated(){
        if (!(UserDefaults.standard.string(forKey: "photoProfil") ?? "").isEmpty){
            profilPic.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "photoProfil")!)
        }else{
            profilPic.image = UIImage(named: "apple")
        }
        if (!(UserDefaults.standard.string(forKey: "prenom") ?? "").isEmpty){
            Name.text = UserDefaults.standard.string(forKey: "nom")!.uppercased() + " " + UserDefaults.standard.string(forKey: "prenom")!
        }else{
            Name.text = UserDefaults.standard.string(forKey: "nom")!.uppercased()
        }
    }
    
    @IBAction func deconnexion(_ sender: Any) {
        promptWithConfirm()
        SBDMain.clearCachedData(completionHandler: nil)
        SBDMain.disconnect(completionHandler: nil)
        
    }

    let webS = UserService()
    
    
    
    
    
    
    func promptWithConfirm(){
        let refreshAlert = UIAlertController(title: "Deconnexion", message: "Etes vous sure de vouloir vous deconnecter ?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            self.clearData()
            self.performSegue(withIdentifier: "deconnexion", sender: "ok")
            
          }))

        refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true) {
                
            }
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
  
}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
