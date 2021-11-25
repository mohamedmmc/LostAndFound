//
//  Article.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 24/11/2021.
//

import Foundation

struct Articles: Codable {
    var articles: [Article]
}

struct Article: Codable {
    var _id:String
    var nom:String
    var description:String
    var addresse:String
    var photo:String?
    var dateCreation:String
    var dateModif:String
    var __v:Int
}
