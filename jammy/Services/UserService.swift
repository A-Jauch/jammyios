//
//  UserService.swift
//  jammy
//
//  Created by Antoine THIEL on 01/05/2021.
//

import Foundation

class UserService {
    private var dataTask: URLSessionDataTask?
    
    func connectUser(identifier:String, password:String,completion: @escaping (Result<Connect, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/login"
        guard let ressourceUrl = URL(string: stringUrl) else {
            fatalError("Error while building url")
        }
        do{
            var urlRequest = URLRequest(url: ressourceUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let user = UserLogin(email: identifier, password: password)
            
            
            let jsonData =  try! JSONEncoder().encode(user)
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
                    let connect = try JSONDecoder().decode(Connect.self, from: data!)
                    completion(.success(connect))
                } catch {
                    completion(.failure(error))
                }
        }
            dataTask.resume()
    }
  }
    
    func me(token: String, completion: @escaping (Result<UserDetails, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/me"
        guard let resourceUrl = URL(string: stringUrl) else {
            fatalError("error while building url")
        }
        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print("failed to read me route")
                    return
                }
                do{
                    let user = try JSONDecoder().decode(UserDetails.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}


