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
        articleImageView.imageFromServerURL(urlString: image!)
        nomArticleLabel.text = nom!
        descriptionArticleLabel.text = desc!
    }
    var nom ,desc,image:String?

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var contactButtonn: UIButton!
    @IBOutlet weak var nomArticleLabel: UILabel!
    @IBOutlet weak var descriptionArticleLabel: UILabel!
    
    
    
    @IBAction func contactButton(_ sender: Any) {
    }
}
