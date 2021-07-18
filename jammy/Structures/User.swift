//
//  User.swift
//  jammy
//
//  Created by Antoine THIEL on 01/05/2021.
//

import Foundation

struct User: Codable {
    var id: Int
    var email: String
    var name: String
    var lastname: String
    var birthday: String
    var user_role: Int
    var role: Role
}

struct UserJam: Codable {
    var id: Int
    var email: String
    var name: String
    var lastname: String
    var birthday: String
    var instrument: Instrument
    var role: Role
}

struct UserQuery: Codable {
    var id: Int
    var email: String
    var name: String
    var lastname: String
    var birthday: String
    var instrument: Instrument
}

struct UserDetails: Codable {
    var success: Bool
    var results: User
}

private enum CodingKeys: String, CodingKey {
    case success, results
}
