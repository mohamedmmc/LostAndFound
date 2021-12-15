//
//  AssociationsController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class AssociationsController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    let tableauAssociation = ["unicef","tunespoir"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return tableauAssociation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let cv = cell.contentView
        let image = cv.viewWithTag(1) as! UIImageView
        let label = cv.viewWithTag(2) as! UILabel
        image.image = UIImage(named: tableauAssociation[indexPath.row])
        label.text = tableauAssociation[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
