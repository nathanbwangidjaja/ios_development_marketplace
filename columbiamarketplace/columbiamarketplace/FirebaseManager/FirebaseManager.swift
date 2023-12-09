//
//  FirebaseManager.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 12/1/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseFunctions {
    static let shared = FirebaseFunctions()

    private init() {}

//    func createUser(withEmail email: String, password: String, fullname: String, uni: String) async throws {
//        do {
//            let result = try await Auth.auth().createUser(withEmail: email, password: password)
//            let user = User(id: result.user.uid, fullname: fullname, uni: uni, email: email, likes: [])
//            let encodedUser = try Firestore.Encoder().encode(user)
//            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
//            await fetchUser()
//        } catch {
//            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
//        }
//    }

    func fetchUser(userID: String, completion: @escaping (User?) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                if let user = try? document.data(as: User.self) {
                    completion(user)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    func fetchFavoriteProducts(user: User, completion: @escaping ([FirebaseProduct]) -> Void) {
        let db = Firestore.firestore()
        let group = DispatchGroup()

        var favoriteProducts: [FirebaseProduct] = []

        for productID in user.likes {
            group.enter()
            db.collection("products").document(productID).getDocument { document, error in
                defer {
                    group.leave()
                }

                if let error = error {
                    print("Error fetching product with ID \(productID): \(error)")
                } else if let document = document, document.exists {
                    if let product = try? document.data(as: FirebaseProduct.self) {
                        favoriteProducts.append(product)
                    }
                }
            }
        }
 

        group.notify(queue: .main) {
            completion(favoriteProducts)
        }
    }
}
