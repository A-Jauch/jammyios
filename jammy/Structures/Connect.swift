//
//  Connect.swift
//  jammy
//
//  Created by Antoine THIEL on 01/05/2021.
//

import Foundation

struct Connect: Codable {
    var accessToken: String
    var success: Bool
}

private enum CodingKeys: String, CodingKey {
    case accessToken, success
}
