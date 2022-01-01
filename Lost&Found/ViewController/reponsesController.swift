//
//  reponsesController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/01/2022.
//

import Foundation
import UIKit

class reponsesController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
                                            self?.handleMarkAsFavourite()
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])

    }
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
        tableReponses?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}
    
    private func handleMarkAsFavourite() {
        print("Marked as favourite")
    }
    
    override func viewDidLoad() {
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
