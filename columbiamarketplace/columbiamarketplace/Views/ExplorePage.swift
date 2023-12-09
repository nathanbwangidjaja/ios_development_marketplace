//
//  ExplorePage.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 11/15/23.
//

//import Foundation
//import SwiftUI
//
//struct Product: Identifiable {
//    let id = UUID()
//    let imageName: String
//    let price: String
//}
//
//struct ExplorePage: View {
//    let products: [Product] = [
//        Product(imageName: "pants", price: "$20"),
//        Product(imageName: "hoodie", price: "$30"),
//        Product(imageName: "shirt", price: "$25"),
//        Product(imageName: "bag", price: "$40"),
//        Product(imageName: "pants", price: "$15"),
//        Product(imageName: "hoodie", price: "$50"),
//        Product(imageName: "shirt", price: "$15"),
//        Product(imageName: "bag", price: "$16")
//    ]
//
//    var body: some View {
//            NavigationView {
//                VStack(spacing: 0) {
//                    // Search Bar
//                    SearchBar()
//
//                    // Filter Bubbles (Replace with your actual filter logic)
//                    FilterBubbles()
//
//                    // Product Grid
//                    ScrollView {
//                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 10) {
//                            ForEach(products) { product in
//                                ProductView(product: product)
//                            }
//                        }
//                        .padding()
//                    }
//
//                    Spacer()
//        
//                }
////                .background(Color(#colorLiteral(red: 0.7764705882, green: 0.8862745098, blue: 0.9137254902, alpha: 1)))
//                .navigationBarHidden(true)
//                .navigationBarTitle(Text("Explore"), displayMode: .inline)
//                .navigationBarItems(trailing: Text("Edit"))
//            }
//        }
//    }

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ExplorePage: View {
    @StateObject var cartManager = CartManager()
    //@EnvironmentObject var favoritesManager = FavoritesManager()
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var products: [FirebaseProduct] = []
    @State private var isUploading = false
    private func uploadAssets() {
            print("hello")
            isUploading = true
            let assetUploader = AssetImageUploader(assetImageNames: ["bag", "greenShoes", "hoodie", "pants", "shirt"])
            assetUploader.uploadAllImages { urls in
                // Handle the uploaded image URLs
                print("Uploaded image URLs: \(urls)")
                isUploading = false
            }
        }
    
    var body: some View {
        NavigationView {
            VStack {
                // Your other UI elements

                // Display Firebase products
                // Product Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 150, maximum: 200), spacing: 10),
                        GridItem(.flexible(minimum: 150, maximum: 200), spacing: 10),
                    ], spacing: 10) {
                        ForEach(products) { product in
                            NavigationLink(
                                destination: ProductDetailsView(product: product)
                                    //.environmentObject(cartManager)
                                    //.environmentObject(favoritesManager)
                                ,
                                label: {
                                    ProductView(product: product)
                                        //.environmentObject(cartManager)
                                        //.environmentObject(favoritesManager)
                                }
                            )
                        }
                    }
                    .padding()
                }
                .onAppear {
                    // Fetch data from Firebase when the view appears
                    fetchFirebaseData()
                }
            }
            .toolbar {
                NavigationLink {
                    //CartView()
                    CartView(product: FirebaseProduct.sampleProduct)
                        //.environmentObject(cartManager)
                } label: {
                    CartButton(numberOfProducts: cartManager.products.count)
                }
            }
            .navigationTitle("Explore")
        }
    }

    private func fetchFirebaseData() {
        // Assuming you have a Firebase Firestore collection named "products"
        let db = Firestore.firestore()
        db.collection("products").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                // Parse the documents and update the products array
                self.products = querySnapshot?.documents.compactMap { document in
                    do {
                        return try document.data(as: FirebaseProduct.self)
                    } catch {
                        print("Error decoding document: \(error)")
                        return nil
                    }
                }.sorted(by: { $0.date_posted.dateValue() > $1.date_posted.dateValue() }) ?? []
            }
        }
    }
}


struct ExplorePage_Previews: PreviewProvider {
    static var previews: some View {
        ExplorePage()
            .environmentObject(CartManager())
            .environmentObject(FavoritesManager())
        
    }
}

// Reusable Search Bar
struct SearchBar: View {
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for items", text: .constant(""))
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
        }
        .padding()
    }
}

// Reusable Filter Bubbles
struct FilterBubbles: View {
    var body: some View {
        // Implement your filter bubbles here
        Text("Filter Bubbles")
            .font(Font.custom(Constants.AppFont.extraBoldFont, size: 25))
            .padding()
    }
}

// Reusable Product View
struct ProductView: View {
    let product: FirebaseProduct
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var isHeartFilled: Bool = false
    
    private var isProductInCart: Bool {
        cartManager.products.contains(where: { $0.id == product.id })
    }
    
    private var isProductInFavorites: Bool {
        favoritesManager.products.contains(where: { $0.id == product.id })
    }

    var body: some View {
        VStack {
            /*
            Image(product.picture)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)
             */
            // Assuming 'product.picture.first' is the URL of the image
            if let imageUrlString = product.picture.first, let imageUrl = URL(string: imageUrlString) {
                AsyncImageView(url: imageUrl)
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                // Placeholder image or view
                Color.gray.frame(height: 200).cornerRadius(10)
            }

            HStack {
                Text("$\(String(format: "%.2f", product.price))")
                    .foregroundColor(.black)
                    .font(.headline)
                    .padding(.leading, 10)
                
                Spacer()
                
                if !isProductInCart {
                    Button(action: {
                        cartManager.addToCart(product: product)
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .padding()
                            .scaleEffect(1.3)
                            .shadow(radius: 2)
                    }
                } else {
                    Image(systemName: "checkmark")
                        .foregroundColor(.black)
                        .padding()
                        .scaleEffect(1.3)
                        .shadow(radius: 2)
                }
                
                if !isProductInFavorites {
                    Button(action: {
                        favoritesManager.addToFavorites(product: product)
                        print("Added to Favorites")
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                            .scaleEffect(1.5)
                            .shadow(radius: 2)
                    }
                    
                } else {
                    Button(action: {
                        favoritesManager.removeFromFavorites(product: product)
                        print("Removed from Favorites")
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(.trailing, 5)
                            .scaleEffect(1.5)
                            .shadow(radius: 2)
                    }
                }
                
                
                /*
                 // Heart Icon Button
                Button(action: {
                    isHeartFilled.toggle() // Toggle heart state
                }) {
                    Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                        .foregroundColor(isHeartFilled ? .red : .white)
                        .padding(.trailing, 5)
                        .scaleEffect(1.5)
                        .shadow(radius: 2)
                }
                .padding(.top, 5)
                */
            }
            //.padding(.horizontal, 1)
            //.onAppear {
                // Set the initial state based on the "favorited" attribute
                //isHeartFilled = product.favorited
            //}
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

