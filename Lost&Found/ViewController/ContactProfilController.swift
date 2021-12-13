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
    var params = SBDUserMessageParams(message: "text")

    var channelURL = ""
    var user:User?
    var usersSB:[SBUUser]?
    var user1,user2,userMod: SBUUser?
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        nomLabel.text = user!.nom + user!.prenom
        photoImageView.imageFromServerURL(urlString: user!.photoProfil)
        user1 = SBUUser(userId: user!._id, nickname: user!.nom, profileUrl: user!.photoProfil)
        user2 = SBUUser(userId: UserDefaults.standard.string(forKey: "_id")!, nickname: UserDefaults.standard.string(forKey: "nom")!, profileUrl: UserDefaults.standard.string(forKey: "photoProfil")!)
        userMod = SBUUser(userId: "357862", nickname: "mod", profileUrl: "")
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            SBDGroupChannel.getWithUrl(self.channelURL) { openChannel, error in
                print("Entering channel url",self.channelURL)
                print("open channel : ",openChannel,"erreur : ", error)
                guard let openChannel = openChannel, error == nil else {
                    return // Handle error.
                }
                openChannel.sendUserMessage("text") { reponse, error in
                }
  
        }
        
    }
        
//        performSegue(withIdentifier: "showChat", sender: nil)
    
    }
}
