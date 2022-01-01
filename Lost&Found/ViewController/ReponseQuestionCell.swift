//
//  ReponseQuestionCell.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 01/01/2022.
//

import UIKit

class ReponseQuestionCell: UITableViewCell {

    @IBOutlet weak var nom: UILabel!
    
    @IBOutlet weak var imageviez: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var nonButton: UIButton!
    static let identifier = "ReponseQuestionCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "ReponseQuestionCell", bundle: nil)
    }
    
    func configure(with title:String){
        nom.text = title
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
