//
//  DetailArticleController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 27/11/2021.
//

import Foundation
import UIKit
import GoogleMaps
class DetailArticleController: UIViewController {
    
    @IBOutlet weak var testGps: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if article!.user._id == UserDefaults.standard.string(forKey: "_id") {
            articleSameUserLabel.text = "C'est votre article"
            contactButtonn.isHidden = true
        }
        articleImageView.imageFromServerURL(urlString: article!.photo!)
        nomArticleLabel.text = article!.nom
        descriptionArticleLabel.text = article!.description!
        if !(article?.addresse ?? []).isEmpty{
            
            let camera = GMSCameraPosition.camera(withLatitude: (article?.addresse![0])!, longitude: (article?.addresse![1])!, zoom: 15)
            testGps.camera = camera
            let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:  (article?.addresse![0])!, longitude: (article?.addresse![1])!)
                    marker.title = "Sydney"
                    marker.snippet = "Australia"
                    marker.map = testGps
        }
        else{
            testGps.isHidden = true
        }
        
    }
    var article :Article?
    var nom ,desc,image:String?

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var contactButtonn: UIButton!
    @IBOutlet weak var nomArticleLabel: UILabel!
    @IBOutlet weak var descriptionArticleLabel: UITextView!
    @IBOutlet weak var articleSameUserLabel: UILabel!
    
    
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
