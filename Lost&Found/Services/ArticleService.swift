//
//  ArticleService.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 22/11/2021.
//

import Foundation
import UIKit


class ArticleService {
    
    
    
    func postArticle(username: String,mdp: String,callback: @escaping (Bool,Any?)->Void){
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
                        if let reponse = jsonRes["user"] as? [String: Any]{
                            
                            for (key,value) in reponse{
                                
                                UserDefaults.standard.setValue(value, forKey: key)
                                
                            }
                            callback(true,"good")
                            
                        }else{
                            callback(false,nil)
                        }
                    }else{
                        callback(false,nil)
                    }
                }
            }
            
        }.resume()
        
    }
    
    
    
    
    
    
    
    
    func AjoutArticle(article:Article, image :UIImage, callback: @escaping (Bool,Any?)->Void){
        
        guard let mediaImage = Media(withImage: image, forKey: "photoProfil") else { return }
        guard let url = URL(string: "http://localhost:3000/article") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        
        let dataBody = DataBody(article:article, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
          
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let test = try decoder.decode(Article.self, from: data)
                        callback(true,test)
                    }catch{
                        print("erreur de decodage (add): ",error)
                        callback(false,"erreur decodage")
                    }
                } else{
                    callback(false,"no data")
                }
            }
        }.resume()
    }

    
    func DataBody(article:Article, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"nom\"\(lineBreak + lineBreak)")
        body.append("\(article.nom! + lineBreak)")
        
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"description\"\(lineBreak + lineBreak)")
        body.append("\(article.description! + lineBreak)")
        
        if !(article.addresse ?? []).isEmpty{
            for element in article.addresse!{
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"addresse\"\(lineBreak + lineBreak)")
                body.append("\(element)" + "\(lineBreak)")
            }
            
        }
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"type\"\(lineBreak + lineBreak)")
        body.append("\(article.type + lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"user\"\(lineBreak + lineBreak)")
        body.append("\(UserDefaults.standard.string(forKey: "_id")! + lineBreak)")
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    func getArticle( callback: @escaping (Bool,Articles?)->Void){
       
        guard let url = URL(string: "http://localhost:3000/article") else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
            if error == nil && data != nil{
                if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                    if jsonRes["message"] == nil{
                        let decoder = JSONDecoder()
                        do {
                            let test = try decoder.decode(Articles.self, from: data!)
                            callback(true,test)
                        } catch  {
                            print(error)
                            callback(false,nil)
                        }
                    }
                    else{
                        callback(false,nil)
                    }
                }
               
            }else{
                callback(false,nil)}
            
         
            
            }
        }.resume()
    }
    
    
}
