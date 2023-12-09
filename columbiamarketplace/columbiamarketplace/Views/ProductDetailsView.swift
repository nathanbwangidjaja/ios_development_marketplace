//
//  ProductDetails.swift
//  columbiamarketplace
//
//  Created by Nira Nair on 11/14/23.

import SwiftUI
import FirebaseFirestore

struct ProductDetailsView: View {
    let product: FirebaseProduct
    @State private var counter: Int = 0
    @State private var isHeartFilled: Bool = false
    @State private var userFullName: String = ""
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private var isProductInCart: Bool {
        cartManager.products.contains(where: { $0.id == product.id })
    }
    private var isProductInFavorites: Bool {
        favoritesManager.products.contains(where: { $0.id == product.id })
    }
    
    var body: some View {
        VStack (spacing: 0){
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.custom("Helvetica", size: 20
                                 ))
                    .fontWeight(.bold)
                    .padding(.leading,20)
                    .padding(.top,5)

                Divider() //grey line
                    .background(Color.gray)
                    .padding(.vertical, 0)
            }
            .frame(maxWidth: .infinity)
        ZStack {
            // Image with AsyncImageView
            if let firstImageUrlString = product.picture.first, let imageUrl = URL(string: firstImageUrlString) {
                AsyncImageView(url: imageUrl)
                    .scaledToFill()
                    .frame(width: 400, height: 400)
                    .cornerRadius(10)
            } else {
                // Placeholder view if no image URL is available
                Color.gray
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            if !isProductInFavorites {
                Button(action: {
                    favoritesManager.addToFavorites(product: product)
                    print("Added to Favorites")
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                        .padding()
                        .scaleEffect(1.5)
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }
                .offset(x: 150, y: -150) // Adjust these values to position the heart icon
                .onAppear {
                    isHeartFilled = product.favorited
                }
                
            } else {
                Button(action: {
                    favoritesManager.removeFromFavorites(product: product)
                    print("Removed from Favorites")
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding()
                        .scaleEffect(1.5)
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }
                .offset(x: 150, y: -150) // Adjust these values to position the heart icon
                .onAppear {
                    isHeartFilled = product.favorited
                }
            }
            
            /*
            // Heart Icon Button
            Button(action: {
                isHeartFilled.toggle() // Toggle heart state
            }) {
                Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                    .foregroundColor(isHeartFilled ? .red : .white)
                    .padding()
                    .scaleEffect(1.5)
                    .background(Circle().fill(Color.white))
                    .shadow(radius: 3)
            }
            .offset(x: 150, y: -150) // Adjust these values to position the heart icon
            .onAppear {
                isHeartFilled = product.favorited
            }
                */
        }
        .padding(.top, 0)
        .edgesIgnoringSafeArea(.top)
        
            // Title
            Button(action: {
                // Action for navigating to a different page
            }) {
                HStack {
                    // Initials in a grey circle
                    Text(extractInitials(from: userFullName))
                        .foregroundColor(.white)
                        .font(.system(size: 18)) // Adjust font size as needed
                        .frame(width: 35, height: 35) // Same dimensions as the original image
                        .background(Color.gray)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))

                    // User Profile Name
                    Button(action: {
                        print("Navigating to UserProfileView with userID: \(product.user)") // Debugging print statement
                        // Action for navigating to a different page
                    }) {
                        NavigationLink(destination: UserProfileView(userID: "\(product.user)")) {
                            Text(userFullName)
                                .font(.custom("Helvetica", size: 18))
                                .bold()
                                .foregroundColor(Color.black)
                        }
                    }
                    .padding(.leading, 0)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    Spacer()
                }
                .onAppear {
                            fetchUserData(userID: product.user) { user, error in
                                if let user = user {
                                    self.userFullName = user.fullname
                                } else {
                                    print("Error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 18)
            .padding(.top, 5)
            .padding(.bottom, 5)
            
            // Description Box
            Text(product.details)

                .padding()
                .lineSpacing(7)
                .background(Color(white: 0.93))
                .cornerRadius(10)
                .font(.custom("Helvetica", size: 18))

            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.vertical, 8)
            // Buttons
            HStack {
                // Price Text
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.custom("Helvetica", size: 23))
                    .fontWeight(.bold)
                    .padding(.leading,20)
                

                Spacer()

                // Delete Button
                if product.user == viewModel.currentUser?.id {
                        // Delete Button for products uploaded by the user
                        Button("Delete") {
                            if let currentUser = viewModel.currentUser {
                                viewModel.deleteProduct(product, for: currentUser) {
                                    // This closure is called after the product is deleted
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 33)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.custom("Helvetica", size: 23))
                        .padding(.trailing, 20)
                    }
                // Buy Now Button
                else if !isProductInCart {
                    Button("Add To Cart") {
                        cartManager.addToCart(product: product)
                        // action
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 33)
                    .background(Color(red: 245 / 255, green: 203 / 255, blue: 92 / 255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.custom("Helvetica", size: 20))
                    .padding(.trailing, 20)
                } else {
                    Image(systemName: "checkmark")
                        .padding()
                        .frame(minWidth: 0, maxWidth: 170, minHeight: 0, maxHeight: 33)
                        .background(Color(red: 245 / 255, green: 203 / 255, blue: 92 / 255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.custom("Helvetica", size: 20))
                        .padding(.trailing, 20)
                        .shadow(radius: 2)
                
                        //.foregroundColor(.black)
                        //.padding()
                        //.scaleEffect(1.3)
                        //.shadow(radius: 2)
                }
            }.edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.top)

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
    }
}


extension FirebaseProduct {
    static var sampleProduct: FirebaseProduct {
        FirebaseProduct(
            id: "1",
            date_posted: Timestamp(date: Date()), // Current date as Timestamp
            details: "This is a detailed description of the sample product.",
            favorited: false,
            name: "Sample Product",
            open_to_trade: true,
            picture: ["hoodie"],
            price: 20.0, // Assuming price is a Double
            user: "iw6XCKvSgQaTJux3NKIE1xVryYl2"
        )
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: FirebaseProduct.sampleProduct)
            .environmentObject(CartManager())
    }
}

func fetchUserData(userID: String, completion: @escaping (User?, Error?) -> Void) {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(userID)

    userRef.getDocument { document, error in
        if let error = error {
            print("Firestore error: \(error.localizedDescription)")
            completion(nil, error)
            return
        }

        if let document = document, document.exists {
            do {
                let user = try document.data(as: User.self)
                print("User found: \(user.fullname)")
                completion(user, nil)
            } catch {
                print("Error decoding user: \(error)")
                completion(nil, error)
            }
        } else {
            print("Document does not exist")
            let error = NSError(domain: "UserProfileError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User document does not exist"])
            completion(nil, error)
        }
    }
}
