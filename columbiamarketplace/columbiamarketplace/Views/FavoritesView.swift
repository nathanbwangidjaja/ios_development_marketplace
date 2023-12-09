//
//  FavoritesView.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 12/1/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    //@State private var user: User?
    @State private var favoriteProducts: [FirebaseProduct] = []
    //@State private var isHeartFilled: Bool = false

    var body: some View {
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        if favoritesManager.products.isEmpty {
                            // Centered Text for empty favorites
                            Text("Favorites Empty")
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .foregroundColor(.gray) // Optional: To style the text
                                .font(.title) // Optional: To style the text
                                .multilineTextAlignment(.center) // Ensures text is centered horizontally
                        } else {
                            // Product Grid for non-empty favorites
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(minimum: 150, maximum: 200), spacing: 10),
                                    GridItem(.flexible(minimum: 150, maximum: 200), spacing: 10)
                                ], spacing: 10) {
                                    ForEach(favoritesManager.products, id: \.id) { product in
                                        NavigationLink(
                                            destination: ProductDetailsView(product: product),
                                            label: {
                                                ProductView(product: product)
                                            }
                                        )
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
        }
    }
/*
    private func fetchUserData() {
        let userID = "iw6XCKvSgQaTJux3NKIE1xVryYl2" // Replace with the actual user ID

        FirebaseFunctions.shared.fetchUser(userID: userID) { user in
            self.user = user

            if let user = user {
                FirebaseFunctions.shared.fetchFavoriteProducts(user: user) { favoriteProducts in
                    self.favoriteProducts = favoriteProducts
                }
            }
        }
    }
    */

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesManager())
    }
}

