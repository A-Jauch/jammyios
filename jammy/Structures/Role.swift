//
//  Role.swift
//  jammy
//
//  Created by Antoine THIEL on 15/05/2021.
//

import Foundation

struct Role:Codable {
    var id: Int
    var name: String
    var description: String
    var is_admin: Bool
    var is_dev: Bool
    var can_create_jam : Bool
}
