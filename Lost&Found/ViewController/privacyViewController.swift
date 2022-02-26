//
//  privacyViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 26/02/2022.
//

import UIKit

class privacyViewController: UIViewController {

    var user:User?
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var Switch: UISwitch!
    @IBAction func Valider(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Un instant...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                                        action in
                                        alert.dismiss(animated: true, completion: nil)}))
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        if Switch.isOn{
            UserService().CreationCompte(user: user!, image: image!) { (succes, reponse) in
                if succes, let json = reponse{
                    print(json)
                        SendBirdApi().SendBirdCreateAccount(user_id: UserDefaults.standard.string(forKey: "_id")!, nickname:  UserDefaults.standard.string(forKey: "nom")!, profile_url:  UserDefaults.standard.string(forKey: "photoProfil")!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            print("on va eliminer l'alert")
                        alert.dismiss(animated: true, completion: nil)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            self.performSegue(withIdentifier: "connexion", sender: nil)
                        }
                    
                }
                else if (reponse == "mail existant"){
                    alert.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {


                        self.propmt(title: "Echec", message: "Mail deja Existant")}
                    
                }
                else if (reponse == "num existant"){
                    alert.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {


                        self.propmt(title: "Echec", message: "Numero deja Existant")}
                    
                    
                }
            }
        }else{
            alert.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {


                self.propmt(title: "Echec", message: "Vous devez accepter les conditions !")

            
        }
        }
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
