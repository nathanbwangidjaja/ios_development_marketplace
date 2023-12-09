//
//  UserProfileView.swift
//  columbiamarketplace
//
//  Created by Nira Nair on 12/4/23.
//
import SwiftUI
import FirebaseFirestore

struct InitialsView: View {
    let initials: String

    var body: some View {
        Text(initials)
            .foregroundColor(.white)
            .font(.system(size: 40))
            .frame(width: 80, height: 80)
            .background(Color.gray)
            .clipShape(Circle())
            .padding(.bottom, 20)
            .padding(.leading,15)
    }
}
struct UserProfileView: View {
    
    var userID: String
    @State private var user: User?
    @State private var products: [FirebaseProduct] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 10) {
                    if let user = user {
                        // Use InitialsView here
                        InitialsView(initials: extractInitials(from: user.fullname))

                        VStack(alignment: .leading, spacing: 10) {
                            Text(user.fullname)
                                .font(.custom("Helvetica", size: 24))
                                .bold()
                                .padding(.top,8)
                            Text(user.email)
                                .font(.custom("Helvetica", size: 18))
                        }
                        .padding(.leading,10)
                    } else if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                    } else {
                        Text("Loading user information...")
                    }
                }
                Text("Current Listings")
                    .font(.custom("Helvetica", size: 18))
                    .padding(.top,10)
                    .padding(.bottom, 15)
                    .padding(.leading, 10)
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(products, id: \.id) { product in
                            NavigationLink(destination: ProductDetailsView(product: product)) {
                                if let imageUrlString = product.picture.first, let imageUrl = URL(string: imageUrlString) {
                                    AsyncImageView(url: imageUrl) // Use your async image view
                                        .frame(width: 120, height: 120)
                                } else {
                                    Text("Image not available")
                                        .frame(width: 120, height: 120)
                                        .background(Color.gray)
                                }
                            }
                        }
                    }
                    Spacer()
                    //.padding(.top)
                }
                .padding(.top)
            }
        }
        .onAppear {
            fetchUserDetails(userID: userID) { fetchedUser, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let fetchedUser = fetchedUser {
                    self.user = fetchedUser
                    fetchProductDetails(productIDs: fetchedUser.uploadedProductIDs)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)

    }

    private func fetchProductDetails(productIDs: [String]) {
        let db = Firestore.firestore()
        for id in productIDs {
            db.collection("products").document(id).getDocument { (document, error) in
                if let document = document, document.exists, let product = try? document.data(as: FirebaseProduct.self) {
                    self.products.append(product)
                }
            }
        }
    }
}

func fetchUserDetails(userID: String, completion: @escaping (User?, Error?) -> Void) {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(userID)

    userRef.getDocument { document, error in
        if let error = error {
            completion(nil, error)
            return
        }

        guard let document = document, document.exists, let user = try? document.data(as: User.self) else {
            completion(nil, NSError(domain: "UserProfileError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User document does not exist or is in the wrong format"]))
            return
        }

        completion(user, nil)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(userID: "0fPmTjbk3xWHrvLzxeUHRFI8GQ32")
    }
}

func extractInitials(from name: String) -> String {
    let names = name.split(separator: " ")
    let initials = names.compactMap { $0.first }.prefix(2)
    return String(initials)
}
