//
//  WebService.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 14/11/2021.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginRequestBody: Codable{
    let username: String
    let password: String
}

struct CreateAccountRequestBody: Codable{
    let nom: String
    let prenom: String
    let email: String
    let numtel: Int
    let password: String
    
}

struct UserResponse: Codable{
    let token: String?
    let message: String?
    let success: Bool?
}

class Webservice{
    func login(username: String,mdp: String){
        let params = [
            "email": username,
            "password":mdp,
        ]
        guard let url = URL(string: "http://192.168.1.7:3000/user/login") else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("there is error")
            }else {
                let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] )
                print(jsonRes)
            }
        }.resume()
    }
    
    func creationCompte(user: User) {
        let params = [
            "nom":user.nom,
            "prenom":user.prenom,
            "email": user.email,
            "password":user.mdp,
            "numt":user.numT
        ]
        guard let url = URL(string: "http://192.168.1.7:3000/user") else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("there is error")
            }else {
                let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] )
                print(jsonRes)
            }
        }.resume()
        
    }
    
    func getUser(){
        guard let url = URL(string: "http://192.168.1.7:3000/user") else{
            return
        }
        let session: Void = URLSession.shared.dataTask( with: url)
        {
            data, response, error in
            if error != nil{
                print("there is error")
            }else {
                let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] )
                print("hello\(String(describing: jsonRes))")
            }
        }.resume()
    }
}
