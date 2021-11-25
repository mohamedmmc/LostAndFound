//
//  WebService.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 14/11/2021.
//

import Foundation
import UIKit
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

class UserService {
    
    
    func loginSocialMedia(username: String,callback: @escaping (Bool,Any?)->Void){
        
        let params = [
            "email": username
        ]
        guard let url = URL(string: "http://localhost:3000/user/Auth") else{
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
                    //print("++++++++++++",data)
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                       print("probleme ici", jsonRes)
                        if jsonRes["token"] != nil {
                           
                            
                            UserDefaults.standard.setValue(jsonRes["token"], forKey: "tokenConnexion")
                        }
                        if let reponse = jsonRes["user"] as? [String: Any]{
                            for (key,value) in reponse{
                               // print("++++++++++",key,value)
                                UserDefaults.standard.setValue(value, forKey: key)
                                
                            }
                            UserDefaults.standard.setValue("", forKey: "password")
                            callback(true,"good")
                            
                        }else{
                            callback(false,"pas inscrit")
                        }
                    }else{
                        callback(false,nil)
                    }
                }
            }
            
        }.resume()
        
    }
    
    
    
    func login(username: String,mdp: String,callback: @escaping (Bool,Any?)->Void){
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
                        if jsonRes["token"] != nil {
                           
                            
                            UserDefaults.standard.setValue(jsonRes["token"], forKey: "tokenConnexion")
                        }
                        if let reponse = jsonRes["user"] as? [String: Any]{
                            
                            for (key,value) in reponse{
                                
                                UserDefaults.standard.setValue(value, forKey: key)
                                
                            }
                            callback(true,"good")
                            
                        }else{
                            callback(false,jsonRes)
                        }
                    }else{
                        callback(false,"erreur ici")
                    }
                }
            }
            
        }.resume()
        
    }
    
    func DataBodyWithoutPass(user:User, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"nom\"\(lineBreak + lineBreak)")
        body.append("\(user.nom + lineBreak)")
        
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"prenom\"\(lineBreak + lineBreak)")
        body.append("\(user.prenom + lineBreak)")
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"email\"\(lineBreak + lineBreak)")
        body.append("\(user.email + lineBreak)")
        
        
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
    
    func DataBody(user:User, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"nom\"\(lineBreak + lineBreak)")
        body.append("\(user.nom + lineBreak)")
        
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"prenom\"\(lineBreak + lineBreak)")
        body.append("\(user.prenom + lineBreak)")
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"email\"\(lineBreak + lineBreak)")
        body.append("\(user.email + lineBreak)")
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"password\"\(lineBreak + lineBreak)")
        body.append("\(user.mdp + lineBreak)")
        
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"numt\"\(lineBreak + lineBreak)")
        body.append("\(user.numT + lineBreak)")
        
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
    
    
    
    
    
    
    func CreationCompte(user:User, image :UIImage, callback: @escaping (Bool,String?)->Void){
        
        guard let mediaImage = Media(withImage: image, forKey: "photoProfil") else { return }
        guard let url = URL(string: "http://localhost:3000/user") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        
        let dataBody = DataBody(user:user, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response {
                }
                if let data = data {
                    do {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            
                            if let reponse = json["reponse"] as? String{
                                if (reponse.contains("email")){
                                    callback(false,"mail existant")
                                }
                                else if (reponse.contains("numt")){
                                    callback(false,"num existant")
                                }
                                else if (reponse == "good"){
                                    if json["token"] != nil {
                                       
                                        
                                        UserDefaults.standard.setValue(json["token"], forKey: "tokenConnexion")
                                    }
                                    if let validUser = json["user"] as? [String:Any]{
                                        
                                        for (key,value) in validUser{
                                            UserDefaults.standard.setValue(value, forKey: key)
                                        }
                                    }
                                    callback(true,"ok")
                                }
                            }
                        }
                    } catch {
                        callback(false,nil)
                    }
                }else{
                    callback(false,nil)}}
        }.resume()
    }
    

    
    func getUser(token:String,callback: @escaping (Bool,Any?)->Void){
        guard let url = URL(string: "http://192.168.1.7:3000/user/login") else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async {
                if error != nil{
                    print("there is error")
                }else {
                    if let jsonRes  = try? JSONSerialization.jsonObject(with: data!, options:[] ) as? [String: Any]{
                        if var reponse = jsonRes["user"] as? String{
                            callback(true,reponse)
                            //print(reponse)
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
    
    
    func CreationCompteSocial(user:User, image :UIImage, callback: @escaping (Bool,String?)->Void){
        
        guard let mediaImage = Media(withImage: image, forKey: "photoProfil") else { return }
        guard let url = URL(string: "http://localhost:3000/user/Social") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        //print("AAAAAAAAAAAA", user)
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        
        let dataBody = DataBodyWithoutPass(user:user, media: [mediaImage], boundary: boundary)
        //print(dataBody)
        request.httpBody = dataBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                       // print("data lenna ",data)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            if let reponse = json["reponse"] as? String{
                                if (reponse.contains("email")){
                                    callback(false,"mail existant")
                                }
                                else{
                                    if let connexionToken = json["token"] as? String{
                                        //print(connexionToken)
                                        UserDefaults.standard.setValue(connexionToken, forKey: "connexionToken")
                                    }
                                    if let validUser = json["user"] as? [String:Any]{
                                        for (key,value) in validUser{
                                            //print("cle = ",key, "Valeur =",value)
                                            UserDefaults.standard.setValue(value, forKey: key)
                                        }
                                    }
                                    callback(true,"ok")
                                }
                            }
                        }
                    } catch {
                        callback(false,nil)
                    }
                }else{
                    callback(false,nil)}
                
            }
        }.resume()
    }
    
    func UpdateProfil(user:User, image :UIImage, callback: @escaping (Bool,String?)->Void){
        
        guard let mediaImage = Media(withImage: image, forKey: "photoProfil") else { return }
        guard let url = URL(string: "http://localhost:3000/user/"+UserDefaults.standard.string(forKey: "_id")!) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        //create boundary
        
        let boundary = generateBoundary()
        //set content type
        request.setValue( "Bearer \(UserDefaults.standard.string(forKey: "tokenConnexion")!)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //print("token est la : ",UserDefaults.standard.string(forKey: "tokenConnexion")!)
        //call createDataBody method
        
        let dataBody = DataBody(user:user, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response {
                }
                if let data = data {
                    do {
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            if let reponse = json["reponse"] as? String{
                               // print(json)
                                if (reponse.contains("updated")){
                                    if let validUser = json["user"] as? [String:Any]{
                                        for (key,value) in validUser{
                                            UserDefaults.standard.setValue(value, forKey: key)
                                        }
                                    }
                                    callback(true,"updated")
                                   
                                }
                                else{
                                    callback(false,"ICIIII")
                                }
                            } else{
                                callback(false,"erreur")
                            }
                        }
                    } catch {
                        callback(false,nil)
                    }
                }else{
                    callback(false,nil)}}
        }.resume()
    }
    
}







extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        let urlStringNew = urlString.replacingOccurrences(of: " ", with: "%20")
        URLSession.shared.dataTask(with: NSURL(string: urlStringNew)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
