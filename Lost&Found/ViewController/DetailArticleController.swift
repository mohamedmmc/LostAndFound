//
//  DetailArticleController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 27/11/2021.
//

import Foundation
import UIKit

class DetailArticleController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        articleImageView.imageFromServerURL(urlString: article!.photo!)
        nomArticleLabel.text = article!.nom
        descriptionArticleLabel.text = article!.type + "/n" + article!.description!
    }
    var article :Article?
    var nom ,desc,image:String?

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var contactButtonn: UIButton!
    @IBOutlet weak var nomArticleLabel: UILabel!
    @IBOutlet weak var descriptionArticleLabel: UITextView!

    
    @IBAction func contactButton(_ sender: Any) {
        performSegue(withIdentifier: "contactProfil", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactProfil" {
            let destination = segue.destination as! ConstactProfilController
            destination.user = article?.user
        }
    }
}
