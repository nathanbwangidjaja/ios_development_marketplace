//
//  CartManager.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 12/1/23.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var products: [FirebaseProduct] = []
    
    func addToFavorites(product: FirebaseProduct){
        products.append(product)
    }
    
    func removeFromFavorites(product: FirebaseProduct) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            // Remove the first instance of the product
            products.remove(at: index)
        }
    }
}
