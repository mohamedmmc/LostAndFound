//
//  User.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 12/11/2021.
//

import Foundation

struct User: Codable {
    let id:String
    let nom:String
    let prenom:String
    let email:String
    let mdp:String
    let numT:String
    let photoP:String
    public let token:String
    
 
    
    init(id:String, nom:String,prenom:String,email:String,mdp:String,numtel:String,photoP:String,token:String) {
        self.id=""
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.mdp=mdp
        self.numT=numtel
        self.photoP = photoP
        self.token=""
    }
    
    
}
