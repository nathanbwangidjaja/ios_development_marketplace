//
//  Product.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 11/15/23.
//


// data model for products
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirebaseProduct: Identifiable, Codable {
    @DocumentID var id: String?
    var date_posted: Timestamp
    var details: String
    var favorited: Bool
    var name: String
    var open_to_trade: Bool
    var picture: [String]
    var price: Double
    var user: String
}
