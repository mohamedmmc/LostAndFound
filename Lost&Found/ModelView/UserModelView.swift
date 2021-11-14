//
//  UserModelView.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 14/11/2021.
//

import Foundation
class UserModelView: ObservableObject {
    
    
    func login(username:String,mdp:String){
        Webservice().login(username: username, mdp: mdp)
    }
    
    func createAccount(nom:String,prenom:String,email:String,mdp:String,numtel:String){
        let user = User(nom: nom,prenom: prenom,email: email,mdp: mdp,numtel: numtel)
        Webservice().creationCompte(user: user)
        }
}
