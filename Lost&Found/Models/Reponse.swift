//
//  Reponse.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 31/12/2021.
//

import Foundation

class Reponses: Decodable {
    var reponses : [Reponse]?
}

class Reponse: Decodable {
    var __v:Int?
    var _id:String?
    var description:String?
    var user:User?
}
