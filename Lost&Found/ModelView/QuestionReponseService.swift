//
//  QuestionReponseService.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 29/12/2021.
//

import Foundation

class QuestionReponseService {
    func AjoutQuestion (titreQuestion:String,idArticle:String,callback: @escaping (Bool,Any?)->Void){
        let params = [
            "titre": titreQuestion,
            "article": idArticle
        ]
        guard let url = URL(string: "https://lost-and-found-back.herokuapp.com/question") else{
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
                    print(error)
                }else {
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if let question  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{

                                callback(true,question)
                            
                            }
                            
                        else{
                            callback(false,"question non ajoute")
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    
    func ReponseQuestion (reponse:String,idQuestion:String,callback: @escaping (Bool,Any?)->Void){
        let params = [
            "description": reponse,
            "user": UserDefaults.standard.string(forKey: "_id")!
        ]
        guard let url = URL(string: "https://lost-and-found-back.herokuapp.com/reponse/"+idQuestion) else{
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error)
                }else {
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if let reponse  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                            if let reponse = jsonRes["message"] as? String{
                                if (reponse.contains("duplicate")){
                                    callback(false,"existe")
                                }
                            }
                                callback(true,reponse)
                            
                        }
                        else{
                            callback(false,"reponse non ajoute")
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    
    
    
    func getReponsesParArticle (idArticle:String,callback: @escaping (Bool,Reponses?)->Void){
        
        guard let url = URL(string: "https://lost-and-found-back.herokuapp.com/reponse/"+idArticle) else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error)
                }else {
                    let decoder = JSONDecoder()
                    do {
                        let test = try decoder.decode(Reponses.self, from: data!)
                        callback(true,test)
                    }catch{
                        print("erreur de decodage (add): ",error)
                        callback(false,nil)
                    }
                }
            }
        }.resume()
    }
    
    
    
    
    func deleteReponse (idArticle:String,callback: @escaping (Bool,String)->Void){
        
        guard let url = URL(string: "https://lost-and-found-back.herokuapp.com/reponse/"+idArticle) else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print(error)
                }else {
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if jsonRes["message"] as! String == "on supprime"{
                            callback(true,jsonRes["message"] as! String)
                        }
                        else{
                            callback(false,"erreur suppression reponse")
                        }
                    }
                }
            }
        }.resume()
    }
}
