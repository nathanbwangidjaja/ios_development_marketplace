//
//  Cart.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 12/1/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage

struct CartView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    let product: FirebaseProduct
    @EnvironmentObject var cartManager: CartManager
    @State private var showingSuccessAlert = false
    //@State private var favoriteProducts: [FirebaseProduct] = []
    //@State private var isHeartFilled: Bool = false
    var body: some View {
        ScrollView {
            if cartManager.products.count > 0 {
                ForEach(cartManager.products, id: \.id) {
                    product in
                    ProductRow(product:product)
                }
                
                HStack{
                    Text("Your cart total is")
                    Spacer()
                    
                    //Text("$\(cartManager.total).00")
                    Text("$\(String(format: "%.2f", cartManager.total))")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .padding()
                Button(action: {
                    deleteProductsFromFirebase()
                    cartManager.clearCart()
                    
                    print("Apple Pay button tapped")
                    showingSuccessAlert = true
                    print(showingSuccessAlert)
                    
                        }) {
                            HStack {
                                Text("Check out with ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .medium))
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                    .foregroundColor(.white)
                                Text("Pay")
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .medium))
                                
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 50)
                        .background(Color.black)
                        .cornerRadius(8)

            } else {
                Text("Your cart is empty")
            }
        }
        .navigationTitle("My Cart")
        .padding(.top)
        .alert(isPresented: $showingSuccessAlert) {
            Alert(title: Text("Transaction Complete"),
                                  message: Text("Your purchase was successful."),
                                  dismissButton: .default(Text("OK")))
        }
    }
    private func deleteProductsFromFirebase() {
        let db = Firestore.firestore()

        for product in cartManager.products {
            if let productId = product.id {
                // Delete the product document
                let productDocRef = db.collection("products").document(productId)
                productDocRef.delete { error in
                    if let error = error {
                        print("Error deleting product: \(error.localizedDescription)")
                    } else {
                        print("Successfully deleted product")
                        // Update the user's document
                        let userDocRef = db.collection("users").document(product.user)
                        userDocRef.updateData([
                            "uploadedProductIDs": FieldValue.arrayRemove([productId])
                        ]) { error in
                            if let error = error {
                                print("Error updating user document: \(error.localizedDescription)")
                            } else {
                                print("Successfully updated user document")
                            }
                        }
                    }
                }
            }
        }
    }

    
}



struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(product: FirebaseProduct.sampleProduct)
            .environmentObject(CartManager())
    }
}
