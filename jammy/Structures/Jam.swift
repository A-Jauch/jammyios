//
//  Jam.swift
//  jammy
//
//  Created by Antoine THIEL on 04/05/2021.
//

import Foundation

struct Jam: Codable{
    var id: Int
    var creator_id: Int
    var name: String
    var description: String
    var createdAt: String
}


struct JamCreate: Codable {
    var creator: Int
    var name: String
    var description: String
}


struct JamCreateResponse : Codable {
    var success: Bool
    var results: Jam
}

struct JamByIdResult : Codable {
    var success: Bool
    var results: [Jam]
    
}

struct JamDeleteResult : Codable {
    var success: Bool
}

struct JamDeleteUser : Codable {
    var user_id : Int
    
}
