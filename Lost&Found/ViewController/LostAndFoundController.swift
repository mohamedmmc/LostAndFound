//
//  FoundController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class LostAndFoundController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableArticle: UITableView!
    //let articleTotal = MySubclassedTabBarController().articleTotal
    var dernierTableau = [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ArticleService().getArticle { succes, reponse in
            if succes {
                for article in reponse!.articles{
                    self.dernierTableau.append(article)
                    self.tableArticle.reloadWithAnimation()
//
                }
            }
            else{
                print("pas d'article a afficher")
            }
        }
        
        tableArticle.reloadData()

    }
    

    @IBAction func AddItem(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dernierTableau.count  }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHome",for: indexPath)
        let cv = cell.contentView
        let image = cv.viewWithTag(1) as! UIImageView
        let nom = cv.viewWithTag(2) as! UILabel
        let description = cv.viewWithTag(3) as! UILabel
        description.text = dernierTableau[indexPath.row].description
        nom.text = dernierTableau[indexPath.row].nom
        image.imageFromServerURL(urlString: dernierTableau[indexPath.row].photo!)
        
        return cell
    }}
    
    

extension UITableView {

    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
