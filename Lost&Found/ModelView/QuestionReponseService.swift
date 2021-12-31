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
                                callback(true,question)}
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
                                callback(true,reponse)}
                        else{
                            callback(false,"reponse non ajoute")
                        }
                    }
                }
            }
        }.resume()
    }
}
