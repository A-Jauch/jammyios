//
//  Queries.swift
//  jammy
//
//  Created by Antoine THIEL on 01/06/2021.
//

import Foundation


class QueriesService {
    private var dataTask: URLSessionDataTask?

    func getQueriesByJam(token: String, jamId:Int, completion: @escaping (Result<QueryByJamResult, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/query/jam/\(jamId)"
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
                    let queries = try JSONDecoder().decode(QueryByJamResult.self, from: data!)
                    completion(.success(queries))
                } catch {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
    
    func updateQuery(token: String, queryId: Int, jamId: Int, userId: Int, accept: Int, completion: @escaping (Result<QueryUpateResult, Error>) -> Void){
        let stringUrl = "https://api.jammy.ovh/query/\(queryId)"
        guard let resourceUrl = URL(string: stringUrl) else {
            fatalError("Error while building url")
        }
        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let query = QueryUpdateQuery(participant: userId, jam: jamId, status: accept)
            
           
           
           let jsonData =  try! JSONEncoder().encode(query)
           urlRequest.httpBody = jsonData
            print(jsonData)
            
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
                    let result = try JSONDecoder().decode(QueryUpateResult.self, from: data!)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
    }
}

