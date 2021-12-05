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
class ProfileController: UIViewController {
    var darkTheme = false
    let dropDown = DropDown()
    let Design = DesignUi()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var settingsUIbutton: UIBarButtonItem!
    @IBOutlet weak var profilPic: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBAction func settingsUibuttonTapped(_ sender: Any) {
        dropDown.show()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let initialLocation = CLLocation(latitude: 21, longitude: -158)
        dropDown.anchorView = settingsUIbutton // UIView or UIBarButtonItem
        dropDownSelector()
        dropDown.dataSource = ["Securite","Modifier Profil","Theme","Déconnexion","Supprimer Profil"]
        dropDown.selectionBackgroundColor = .blue

        profileUpdated()
        profilPic.contentMode = UIView.ContentMode.scaleAspectFit
        
        profilPic.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "photoProfil")!)
        Design.RadiusImage(titre: profilPic!, radius: 5,width: 2,Bordercolor: .white)
        
        let name = Notification.Name("updateProfil")
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated), name: name, object: nil)
        
    }
    func dropDownSelector (){
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if (item == "Modifier Profil"){
                performSegue(withIdentifier: "modifierProfil", sender: nil)
            }
            else if (item == "Theme"){
                let refreshAlert = UIAlertController(title: "Changer theme", message: "Etes vous sure de vouloir changer de theme ?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    if !darkTheme{
                        UIApplication.shared.windows.forEach { window in
                            window.overrideUserInterfaceStyle = .dark
                            print("change dark")
                            darkTheme = true
                        }
                    }
                    else{
                        UIApplication.shared.windows.forEach { window in
                            window.overrideUserInterfaceStyle = .light
                            print("change light")
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
                    UserService().deleteProfil { succes, reponse in
                        if succes{
                            self.clearData()
                            self.performSegue(withIdentifier: "deconnexion", sender: "ok")
                        }
                    }
                }))
                refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
                    refreshAlert.dismiss(animated: true) {
                    }
                }))
                present(refreshAlert, animated: true, completion: nil)
                
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
    
    

    
    @objc func profileUpdated(){
        profilPic.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: "photoProfil")!)
        Name.text = UserDefaults.standard.string(forKey: "nom")!.uppercased() + " " + UserDefaults.standard.string(forKey: "prenom")!
    }
    
    @IBAction func deconnexion(_ sender: Any) {
        promptWithConfirm()
        
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
