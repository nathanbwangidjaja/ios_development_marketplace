//
//  columbiamarketplaceApp.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 11/14/23.
//

import SwiftUI
import Firebase

@main
struct columbiamarketplaceApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var favoriteManager = FavoritesManager()
    @StateObject var cartManager = CartManager()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(favoriteManager)
                .environmentObject(cartManager)
        }
    }
}
