//
//  WebService.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 14/11/2021.
//

import Foundation


class Webservice{
    private static let picUrl = URL(string: "https://source.unsplash.com/random")!
    
    
    
     func login(username: String,mdp: String,callback: @escaping (Bool,String?)->Void){
        let params = [
            "email": username,
            "password":mdp,
        ]
        guard let url = URL(string: "http://localhost:3000/user/login") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print("error")
                }else {
                    
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if let reponse = jsonRes["reponse"] as? String{
                            if (reponse == "good") {
                                callback(true,reponse)
                            }
                            else{callback(false,reponse)}
                        }
                    }else{
                        callback(false,nil)
                    }
                }
            }
            
        }.resume()
        
    }
    
    /*private static func getImg(){
     let session = URLSession(configuration: .default)
     let task = session.dataTask(with: picUrl) { data,response,error in
     if let data = data, error == nil{
     if let response = response as? HTTPURLResponse, response.statusCode == 200{
     
     }
     }
     }.resume()
     }*/
    
    func creationCompte(user: User, callback: @escaping (Bool,String?)->Void){
        let params = [
            "nom":user.nom,
            "prenom":user.prenom,
            "email": user.email,
            "password":user.mdp,
            "numt":user.numT
        ]
        guard let url = URL(string: "http://localhost:3000/user") else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print("there is error")
                }else {
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if var reponse = jsonRes["nom"] as? String{
                            callback(true,reponse)
                        }
                        else{
                            callback(false,nil)
                        }
                    }else{
                        callback(false,nil)
                    }
                }
            }
            
        }.resume()
    }
    
    func getUser(user:User,callback: @escaping (Bool,Any?)->Void){
        guard let url = URL(string: "http://192.168.1.7:3000/user/") else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print("there is error")
                }else {
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if var reponse = jsonRes["nom"] as? String{
                            callback(true,reponse)
                        }
                        else{
                            callback(false,nil)
                        }
                    }else{
                        callback(false,nil)
                    }
                }
            }
            
        }.resume()
    }
}
