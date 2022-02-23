//
//  User.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 12/11/2021.
//

import Foundation

struct User: Codable {
    var _id:String
    var nom:String
    var prenom:String?
    var email:String
    var mdp:String?
    var numT:String?
    var photoProfil:String?
    var isVerified:Bool
    var __v:Int

 
    
    init(id:String, nom:String,prenom:String,email:String,mdp:String,numtel:String,photoProfil:String,isVerified:Bool,__v:Int) {
        self._id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.mdp=mdp
        self.numT=numtel
        self.photoProfil = photoProfil
        self.isVerified = isVerified
        self.__v = 0
    }
    
    init(id:String, nom:String,prenom:String,email:String,photoProfil:String,isVerified:Bool,__v:Int) {
        self._id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.photoProfil = photoProfil
        self.isVerified = isVerified
        self.__v = 0
    }
    
}
