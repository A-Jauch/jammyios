//
//  Queries.swift
//  jammy
//
//  Created by Antoine THIEL on 01/06/2021.
//

import Foundation

struct Queries: Codable{
    var id: Int
    var status: Int
    var user: UserQuery
    var jam: Jam
    
}

struct QueryByJamResult: Codable{
    var success: Bool
    var results: [Queries]
}

struct QueryUpateResult: Codable{
    var success: Bool
}

struct QueryUpdateQuery : Codable {
    var user_id: Int
    var jam_id: Int
    var status: Int
}
