//
//  UserLogin.swift
//  jammy
//
//  Created by Antoine THIEL on 01/05/2021.
//

import Foundation

struct UserLogin: Codable {
    var email: String
    var password: String
}

private enum CodingKeys: String, CodingKey {
    case email, password
}
