//
//  Session.swift
//  jammy
//
//  Created by Antoine THIEL on 26/05/2021.
//

import Foundation

struct Session: Codable {
    var jam: Jam;
    var user: UserJam;
}

struct SessionByJamId: Codable {
    var success: Bool
    var results: [Session]
}
