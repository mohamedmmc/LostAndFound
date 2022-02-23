//
//  ContactProfilController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/12/2021.
//

import Foundation
import UIKit
import SendBirdUIKit
class ConstactProfilController: UIViewController {
    var params = SBDUserMessageParams(message: "Bonjour je vous contact concernant le produit que vous avez posté")

    var channelURL = ""
    var user:User?
    var usersSB:[SBUUser]?
    var user1,user2: SBUUser?
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    var prenom = " "
    var photo = " "
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if (!(UserDefaults.standard.string(forKey: "prenom") ?? "").isEmpty){
            prenom = UserDefaults.standard.string(forKey: "prenom")!
            
        }
        nomLabel.text = user!.nom + user!.prenom!
        if !(user!.photoProfil ?? "").isEmpty{
            photoImageView.imageFromServerURL(urlString: user!.photoProfil!)
            photo = user!.photoProfil!
        }else{
            photoImageView.image = UIImage(named: "apple")
        }
        user1 = SBUUser(userId: user!._id, nickname: user!.nom, profileUrl: photo)
        if !(UserDefaults.standard.string(forKey: "photoProfil") ?? "").isEmpty{
            photo = UserDefaults.standard.string(forKey: "photoProfil")!
        }
        user2 = SBUUser(userId: UserDefaults.standard.string(forKey: "_id")!, nickname: UserDefaults.standard.string(forKey: "nom")!, profileUrl: photo)
        
    }
    
    @IBAction func envoyerMessage(_ sender: Any) {
        SBDMain.connect(withUserId: UserDefaults.standard.string(forKey: "_id")!, completionHandler: { (user, error) in
            guard error == nil else {
                print("erreur function : ",error)
                return
            }
        })
            SBDGroupChannel.createChannel(withUserIds: Array(arrayLiteral: self.user2!.userId,self.user1!.userId), isDistinct: true) { data, error in
                
                self.channelURL = data!.channelUrl
                print("Created channel url : ",self.channelURL)
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SBDGroupChannel.getWithUrl(self.channelURL) { openChannel, error in
                print("Entering channel url",self.channelURL)
                print("open channel : ",openChannel,"erreur : ", error)
                guard let openChannel = openChannel, error == nil else {
                    return // Handle error.
                }
                openChannel.sendUserMessage("Bonjour je vous contact concernant le produit que vous avez posté") { reponse, error in
                }
        }
    }
    }
}
