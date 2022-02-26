//
//  FoundController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class LostAndFoundController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UISearchResultsUpdating {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive {
            return tableauFiltre.count
        }
        return dernierTableau.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellHome",for: indexPath)
        let cv = cell.contentView
        let image = cv.viewWithTag(3) as! UIImageView
        let nom = cv.viewWithTag(4) as! UILabel
        let description = cv.viewWithTag(5) as! UILabel
        if searchController.isActive{
            description.text = tableauFiltre[indexPath.row].description
            nom.text = tableauFiltre[indexPath.row].nom
            image.imageFromServerURL(urlString: tableauFiltre[indexPath.row].photo!)
        }
        else{
            description.text = dernierTableau[indexPath.row].description
            nom.text = dernierTableau[indexPath.row].nom
            image.imageFromServerURL(urlString: dernierTableau[indexPath.row].photo!)
        }
        
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearch(searchText: searchText, ScopeButton: scopeButton)
    }
    func filterForSearch(searchText : String, ScopeButton:String){
        tableauFiltre = dernierTableau.filter{
            article in
            let scopeMatch = article.type == ScopeButton
            if (searchController.searchBar.text != ""){
                let searchTextMatch = article.nom?.lowercased().contains(searchText.lowercased())
                return scopeMatch && (searchTextMatch != nil)
            }else{
                return scopeMatch
            }
        }
        tableArticle.reloadData()
    }

    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["Lost","Found"]
        searchController.searchBar.delegate = self
        
    }
    
    let searchController = UISearchController()
    let uiDesign = DesignUi()
    
    @IBOutlet weak var tableArticle: UICollectionView!
    var dernierTableau = [Article]()
    var tableauFiltre = [Article]()
    
     
    override func viewDidLoad() {
        
        initSearchController()
        super.viewDidLoad()
        loadArticleToTableview(tableau:self.tableArticle)
        uiDesign.BorderButton(titre: addbutton, radius: 12, width: 3, Bordercolor: .white)
        let name = Notification.Name("articleAjoute")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        
       
    }
    @IBOutlet weak var backgroundElement: UIView!
 
    
    @IBOutlet weak var addbutton: UIButton!

    @objc func loadArticle(){
        dernierTableau.removeAll()
        loadArticleToTableview(tableau:self.tableArticle)
        }
    
     func loadArticleToTableview (tableau:UICollectionView){
        ArticleService().getArticle { succes, reponse in
            if succes {
                for article in reponse!.articles!{
                    self.dernierTableau.append(article)
                    DispatchQueue.main.async {
                        tableau.reloadData()
                                }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ajouterArticle" {
            let destination = segue.destination as! AjouterArticleController
            destination.test = dernierTableau
        }
        else if segue.identifier == "detailArticle" {
            let index = sender as! IndexPath
            let destination = segue.destination as! DetailArticleController
            if searchController.isActive{
                destination.article = tableauFiltre[index.row]
                
            }
            else{
                destination.article = dernierTableau[index.row]

            }
        }
     
    }

    @IBAction func AddItem(_ sender: Any) {
        if (!UserDefaults.standard.bool(forKey: "isVerified")){
            self.propmt(title: "Confirmation Compte", message: "Veuillez confirmer votre email avec le code envoye")
        }
        else
        {
            performSegue(withIdentifier: "ajouterArticle", sender: tableArticle)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailArticle", sender: indexPath)
    }
    
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
    
    

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
