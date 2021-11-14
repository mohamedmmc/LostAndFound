//
//  User.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 12/11/2021.
//

import Foundation

struct User {
    let nom:String
    let prenom:String
    let email:String
    let mdp:String
    let numT:String
    
 
    
    init( nom:String,prenom:String,email:String,mdp:String,numtel:String) {
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.mdp=mdp
        self.numT=numtel
    }
    
}
