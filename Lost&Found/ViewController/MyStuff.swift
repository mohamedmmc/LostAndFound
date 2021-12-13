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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("le tableau de myStuff contient",tableauMyStuff!.count)
        return tableauMyStuff!.count
    }
    
    @IBOutlet weak var myStuffUITable: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let image = cv?.viewWithTag(6) as! UIImageView
        let label = cv?.viewWithTag(7) as! UILabel
        image.imageFromServerURL(urlString: tableauMyStuff![indexPath.row].photo!)
        label.text = tableauMyStuff![indexPath.row].nom!
        return cell!
    }
    @objc func loadArticle(){
        tableauMyStuff?.removeAll()
        loadArticleToTableview(tableau:self.myStuffUITable)
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
    }
}
