//
//  Cart.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 12/1/23.
//

import Foundation

struct Favorites: Identifiable {
    
    var id = UUID().uuidString
    var product: FirebaseProduct
    var quantity: Int
}
