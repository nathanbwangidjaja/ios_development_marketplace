//
//  CartManager.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 12/1/23.
//

import Foundation

class CartManager: ObservableObject {
    @Published private(set) var products: [FirebaseProduct] = []
    @Published private(set) var total: Double = 0.0
    
    func addToCart(product: FirebaseProduct){
        products.append(product)
        total += product.price
    }
    func removeFromCart(product: FirebaseProduct) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            // Remove the first instance of the product
            products.remove(at: index)
            total -= product.price
        }
    }
    
    func clearCart() {
        products.removeAll()
        total = 0.0
    }
}
