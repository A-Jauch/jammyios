//
//  QueryUser.swift
//  jammy
//
//  Created by Antoine THIEL on 01/06/2021.
//

import Foundation

struct QueryUser: Codable {
    var id = UUID()
    
    let name: String
    let instrument: String
    let queryId: Int
    let participant: UserQuery
    
    init(name: String, instrument: String, queryId: Int, participant: UserQuery) {
        self.name = name
        self.instrument = instrument
        self.queryId = queryId
        self.participant = participant
    }
}

extension QueryUser: Hashable {
    static func ==(lhs: QueryUser, rhs: QueryUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
