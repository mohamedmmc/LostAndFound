//
//  DesignUi.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 13/11/2021.
//

import Foundation
import UIKit

class DesignUi {
    
    public func addLeftIcon(txtField: UITextField, andImage img: UIImage){
        let leftImageView = UIImageView(frame: CGRect(x: 3.0, y: 0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    public func BorderButton(titre:UIButton!,radius:CGFloat,width:CGFloat,Bordercolor:UIColor){
        titre?.layer.cornerRadius = radius
        titre?.layer.borderWidth = width
        titre?.layer.borderColor = Bordercolor.cgColor
    }
    public func BorderLabel(titre:UILabel!,radius:CGFloat,width:CGFloat,Bordercolor:UIColor){
        titre?.layer.cornerRadius = radius
        titre?.layer.borderWidth = width
        titre?.layer.borderColor = Bordercolor.cgColor
    }
}
