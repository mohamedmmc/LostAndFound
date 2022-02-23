//
//  MyStuff.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/12/2021.
//

import Foundation
import UIKit


class MyStuff: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableauMyStuff : [Article]?
    var tableauReponse :[Data]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauMyStuff!.count
    }
    
    @IBOutlet weak var myStuffUITable: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let image = cv?.viewWithTag(6) as! UIImageView
        let label = cv?.viewWithTag(7) as! UILabel
        let questionButton = cv?.viewWithTag(20) as! UIButton
        image.imageFromServerURL(urlString: tableauMyStuff![indexPath.row].photo!)
        label.text = tableauMyStuff![indexPath.row].nom!
        if (tableauMyStuff![indexPath.row].question?.reponse?.count == nil)  {
            questionButton.isHidden = true
        }

       return cell!
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == UITableViewCell.EditingStyle.delete {
           let refreshAlert = UIAlertController(title: "Supprimer reponse", message: "Etes vous sure de vouloir supprimer cet article ?", preferredStyle: UIAlertController.Style.alert)

           refreshAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            ArticleService().deleteArticle(id: self.tableauMyStuff![indexPath.row]._id)
               self.tableauMyStuff?.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)

             }))

           refreshAlert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: { (action: UIAlertAction!) in
               refreshAlert.dismiss(animated: true) {

               }
           }))

           present(refreshAlert, animated: true, completion: nil)

       }
   }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var archive = UIContextualAction()
                if (tableauMyStuff![indexPath.row].question?.reponse?.count == nil)  {
                    archive = UIContextualAction(style: .normal,
                                                     title: "Pas de reponse") { [weak self] (action, view, completionHandler) in
                        self?.handleMoveToArchive(indexPath: indexPath)
                                                        completionHandler(true)
                    }
                    archive.backgroundColor = .systemGray
                }
                else{
                    archive = UIContextualAction(style: .normal,
                                                     title: "Voir reponses") { [weak self] (action, view, completionHandler) in
                        self?.handleMoveToArchive(indexPath: indexPath)
                                                        completionHandler(true)
                    }
                    archive.backgroundColor = .systemGreen
                }
        let configuration = UISwipeActionsConfiguration(actions: [archive])
       
               return configuration
    }

    private func handleMoveToArchive(indexPath:IndexPath) {
        if (tableauMyStuff![indexPath.row].question != nil){
            if (tableauMyStuff![indexPath.row].question?.reponse) != nil {
                performSegue(withIdentifier: "reponseSegue", sender: indexPath)
            }
            else{
                self.propmt(title: "Vide", message: "Cet article n'as recu de reponse")
            }
        }
        else{
            self.propmt(title: "Vide", message: "Cet article n'as pas de question")
        }
    }
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @objc func loadArticle(){
        tableauMyStuff?.removeAll()
        loadArticleToTableview(tableau:self.myStuffUITable)
        }
    @objc func reloadMyStuff(){
        tableauMyStuff?.removeAll()
        loadArticleToTableview(tableau:self.myStuffUITable)
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailMyStuff", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMyStuff" {
            let index = sender as! IndexPath
            let destination = segue.destination as! DetailMyStuffController
            destination.test = tableauMyStuff![index.row]
        }
        else if segue.identifier == "reponseSegue" {
            let index = sender as! IndexPath
            let destination = segue.destination as! reponsesController
            destination.idArticle = tableauMyStuff![index.row]._id
            print("les donnes envoyees : ",tableauMyStuff![index.row].question?.reponse)
            destination.tableReponses = tableauMyStuff![index.row].question?.reponse
        }
        
    }
    
    
    
    
    func loadArticleToTableview (tableau:UITableView){
        ArticleService().getArticleByUser(id: UserDefaults.standard.string(forKey: "_id")!) { succes, articles in
           if succes {
               for article in articles!.articles!{
                print("articles : ",article)
                   self.tableauMyStuff?.append(article)
                   DispatchQueue.main.async {
                       tableau.reloadWithAnimation()
                               }
               }
           }
           else{
            print("erreur ici")
           }
       }
   }
    override func viewDidLoad() {
        loadArticleToTableview(tableau:self.myStuffUITable)
        super.viewDidLoad()
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        let name2 = Notification.Name("updateArticle")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMyStuff), name: name2, object: nil)
        let name3 = Notification.Name("reponseAjoute")
        let notification = Notification(name: name3)
        NotificationCenter.default.post(notification)
        
    }
}


