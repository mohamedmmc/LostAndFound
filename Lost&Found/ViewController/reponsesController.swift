//
//  reponsesController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/01/2022.
//

import Foundation
import UIKit
import SendBirdUIKit

class reponsesController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var params = SBDUserMessageParams(message: "Bonjour je vous reponds concernant votre reponse")
    var usersSB:[SBUUser]?
    var channelURL = ""

    var user1,user2,userMod: SBUUser?
    var tableReponses : [String]?
    var idArticle : String?
    var reponseTab = [Reponse]()
    
    @IBOutlet weak var UiTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print(tableReponses!.count)
        return tableReponses!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let image = cv?.viewWithTag(1) as! UIImageView
        let label = cv?.viewWithTag(2) as! UILabel
        
        if reponseTab.count > 0 {
            image.imageFromServerURL(urlString: reponseTab[indexPath.row].user!.photoProfil)
            label.text = reponseTab[indexPath.row].description
        }
       

       
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Repondre") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite(indexPath: indexPath)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])

    }
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
        let refreshAlert = UIAlertController(title: "Supprimer reponse", message: "Etes vous sure de vouloir supprimer cette reponse ?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            QuestionReponseService().deleteReponse(idArticle: self.reponseTab[indexPath.row]._id!) { succes, reponse in
                if succes{
                    print(reponse)
                }else{
                    print(reponse)
                }
            }
            self.tableReponses?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
          }))

        refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true) {
                
            }
        }))

        present(refreshAlert, animated: true, completion: nil)
       
    }
}
    
    private func handleMarkAsFavourite(indexPath :IndexPath) {
        user1 = SBUUser(userId: reponseTab[indexPath.row].user!._id, nickname: reponseTab[indexPath.row].user?.prenom, profileUrl: reponseTab[indexPath.row].user?.photoProfil)
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
                openChannel.sendUserMessage("Bonjour je vous reponds concernant votre reponse") { reponse, error in
                }
        }
    }

    }
    
    override func viewDidLoad() {
        user2 = SBUUser(userId: UserDefaults.standard.string(forKey: "_id")!, nickname: UserDefaults.standard.string(forKey: "nom")!, profileUrl: UserDefaults.standard.string(forKey: "photoProfil")!)
        reponseTab.removeAll()
        loadReponsesToTableView(tableau: self.UiTableView)
        super.viewDidLoad()
        let name = Notification.Name("reponseAjoute")
        NotificationCenter.default.addObserver(self, selector: #selector(loadReponse), name: name, object: nil)
    }
    @objc func loadReponse(){
        reponseTab.removeAll()
        loadReponsesToTableView(tableau:self.UiTableView)
        }
    
    func loadReponsesToTableView (tableau:UITableView){
        QuestionReponseService().getReponsesParArticle(idArticle: idArticle! ) { succes, reponse in
            if succes{
                for item in reponse!.reponses!{
                    
                    self.reponseTab.append(item)
                    DispatchQueue.main.async {
                        tableau.reloadWithAnimation()
                    }
                }
            }else{
                print(reponse)
            }
        }
    }
    
    
    
}
