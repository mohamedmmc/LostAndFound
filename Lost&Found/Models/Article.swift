//
//  Article.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 24/11/2021.
//

import Foundation

struct Articles: Decodable{
    var articles: [Article]?
}

struct Article: Decodable {
    var _id:String
    var nom:String?
    var description:String?
    var addresse:[Double]?
    var photo:String?
    var dateCreation:String
    var dateModif:String
    var type:String
    var user:User
    var question:Question?
    var __v:Int
}
