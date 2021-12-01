//
//  ContactProfilController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/12/2021.
//

import Foundation
import UIKit

class ConstactProfilController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        nomLabel.text = user!.nom + user!.prenom
        photoImageView.imageFromServerURL(urlString: user!.photoProfil)
    }
    var user:User?
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
}
