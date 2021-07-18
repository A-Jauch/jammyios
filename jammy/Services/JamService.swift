//
//  JamService.swift
//  jammy
//
//  Created by Antoine THIEL on 04/05/2021.
//

import Foundation


class JamService {
    private var dataTask: URLSessionDataTask?

    func createJam(token: String, uId:Int, name:String, description: String, completion: @escaping (Result<JamCreateResponse, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/jam"
        guard let ressourceUrl = URL(string: stringUrl) else {
            fatalError("Error while building url")
        }
        do{
            var urlRequest = URLRequest(url: ressourceUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
             let jam = JamCreate(creator: uId, name: name, description: description)
            
            
            let jsonData =  try! JSONEncoder().encode(jam)
            urlRequest.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard (response as? HTTPURLResponse) != nil else {
                    return
                }
                
                guard data != nil else{
                    return
                }
                
                do{
                    let createdJam = try JSONDecoder().decode(JamCreateResponse.self, from: data!)
                    completion(.success(createdJam))
                } catch {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
    
    
    func getJamsById(token: String, uid: Int, completion: @escaping (Result<JamByIdResult, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/jam/user/\(uid)"
        guard let resourceUrl = URL(string: stringUrl) else {
            fatalError("Error while building Url")
        }
        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {
                data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard (response as? HTTPURLResponse) != nil else {
                    return
                }
                
                guard data != nil else{
                    return
                }
                
                do{
                    let jams = try JSONDecoder().decode(JamByIdResult.self, from: data!)
                    completion(.success(jams))
                } catch {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
    
    func deleteJam(token: String, uId:Int, jamId: Int, completion: @escaping (Result<JamDeleteResult, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/jam/\(jamId)"
        guard let resourceUrl = URL(string: stringUrl) else {
            fatalError("Error while building URL")
        }
        
        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "DELETE"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let jam = JamDeleteUser(user_id: uId)
           
           
           let jsonData =  try! JSONEncoder().encode(jam)
           urlRequest.httpBody = jsonData
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard (response as? HTTPURLResponse) != nil else {
                    return
                }
                
                guard data != nil else{
                    return
                }
                
                do{
                    let deleteJam = try JSONDecoder().decode(JamDeleteResult.self, from: data!)
                    completion(.success(deleteJam))
                } catch {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
}
