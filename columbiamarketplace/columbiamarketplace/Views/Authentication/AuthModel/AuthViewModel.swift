//
//  AuthViewModel.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 11/28/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationProtocol{
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var userProducts: [FirebaseProduct] = []

    private var userListener: ListenerRegistration? // To keep track of the listener
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email:String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser() //need to sign in first before fetch
        } catch {
            print("DEBUG: Failed to login. Error : \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, uni: String, likes: [String], uploadedProductIDs: [String]) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, uni: uni, email: email, likes: [], uploadedProductIDs: [])
            //let user = User(id: result.user.uid, fullname: fullname, uni: uni, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch{
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //user is signed out on backend
            self.userSession = nil //erases userSession and will bring user to login screen
            self.currentUser = nil //deletes currentUser data
            
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    /*
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Create user is \(self.currentUser)")
    }
     */
    func fetchUser() async {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            // Remove existing listener if any
            userListener?.remove()

            // Setup the snapshot listener
            userListener = Firestore.firestore().collection("users").document(uid).addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }
                
                if let snapshot = snapshot, let user = try? snapshot.data(as: User.self) {
                    DispatchQueue.main.async {
                        self?.currentUser = user
                        // Fetch updated products
                        Task {
                            await self?.fetchUserProducts(for: user)
                        }
                    }
                }
            }
        }

    
    func updateUserUploadedProductIDs(with newID: String) {
        guard let currentUserID = self.userSession?.uid else { return }

        Firestore.firestore().collection("users").document(currentUserID).updateData([
            "uploadedProductIDs": FieldValue.arrayUnion([newID])
        ]) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                print("User successfully updated")
                // Optionally, fetch user again to update local data
                Task {
                    await self.fetchUser()
                }
            }
        }
    }
    
    func fetchUserProducts(for user: User) async {
            var products: [FirebaseProduct] = []

            for productID in user.uploadedProductIDs {
                let productRef = Firestore.firestore().collection("products").document(productID)
                do {
                    let snapshot = try await productRef.getDocument()
                    if let product = try? snapshot.data(as: FirebaseProduct.self) {
                        products.append(product)
                    }
                } catch {
                    print("Error fetching product with ID \(productID): \(error)")
                }
            }
            
            DispatchQueue.main.async {
                self.userProducts = products
            }
        }
    
    func deleteProduct(_ product: FirebaseProduct, for user: User, completion: @escaping () -> Void) {
        Firestore.firestore().collection("products").document(product.id ?? "").delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
                Firestore.firestore().collection("users").document(user.id).updateData([
                    "uploadedProductIDs": FieldValue.arrayRemove([product.id ?? ""])
                ]) { error in
                    if let error = error {
                        print("Error updating user: \(error)")
                    } else {
                        print("User successfully updated")
                        completion()
                    }
                }
            }
        }
    }

}
