//
//  SessionService.swift
//  jammy
//
//  Created by Antoine THIEL on 04/05/2021.
//

import Foundation


class SessionService {
    private var dataTask: URLSessionDataTask?

    func getSession(token: String, jamId:Int, completion: @escaping (Result<SessionByJamId, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/session/jam/\(jamId)"
        guard let ressourceUrl = URL(string: stringUrl) else {
            fatalError("Error while building url")
        }
        do{
            var urlRequest = URLRequest(url: ressourceUrl)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
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
                    let sessions = try JSONDecoder().decode(SessionByJamId.self, from: data!)
                    completion(.success(sessions))
                } catch {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
}
