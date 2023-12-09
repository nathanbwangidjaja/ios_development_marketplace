//
//  Message.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 12/3/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
