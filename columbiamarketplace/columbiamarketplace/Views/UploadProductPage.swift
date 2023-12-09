//

//  UploadProductPage.swift
//  columbiamarketplace
//
//  Created by Hanvit Choi on 11/15/23.
//

import UIKit
import SwiftUI
import PhotosUI
import Foundation
import FirebaseFirestore
import FirebaseAuth
import StoreKit
import FirebaseStorage


struct UploadProductPage: View {
    @State private var itemTitle = ""
    @State private var itemDescription = ""
    @State private var category = ""
    @State private var brand = ""
    @State private var condition = ""
    @State private var price = ""
    @State private var openToTrades = false

    @State private var images: [UIImage] = []
    @State private var showingImagePicker = false

    @EnvironmentObject var viewModel: AuthViewModel

    @Environment(\.presentationMode) var presentationMode
    // Add a Binding property to manage the selected tab
    @Binding var selectedTab: Int

    func getCurrentUserID() -> String? {
        //return "0fPmTjbk3xWHrvLzxeUHRFI8GQ32"
        return Auth.auth().currentUser?.uid
    }

    // A function to handle the uploading of images and saving the product data
    func uploadImagesAndSaveProduct() {
            // Start uploading images first, then save product information
            let storage = Storage.storage()
            var imageUrls: [String] = []
            let imageGroup = DispatchGroup()
            guard let userID = getCurrentUserID() else {
                    print("Error: User not logged in")
                    return
                }

            for image in images {
                // UIImage to jpef or png data
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    print("Image data could not be converted")
                    continue }
                let imageName = UUID().uuidString
                let storageRef = storage.reference(withPath: "images/\(imageName).jpg")
                imageGroup.enter()

                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    guard error == nil else {
                        print("Failed to upload image: \(error!.localizedDescription)")
                        imageGroup.leave()
                        return
                    }

                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print("Download URL not found")
                            imageGroup.leave()
                            return
                        }

                    imageUrls.append(downloadURL.absoluteString)
                    imageGroup.leave()
                    }
                }
            }

            imageGroup.notify(queue: .main) {
                // Once all images are uploaded, save the product information
                print("Image URLs: \(imageUrls)")

                let product = FirebaseProduct(
                    id: nil, // not generated yet
                    date_posted: Timestamp(date: Date()),
                    details: itemDescription,
                    favorited: false,
                    name: itemTitle,
                    open_to_trade: false,
                    picture: imageUrls,
                    price: Double(price) ?? 0,
                    user: userID
                )


                let db = Firestore.firestore()
                do {
                    // Convert FirebaseProduct to a dictionary manually
                    let productDict: [String: Any] = [
                        "name": product.name,
                        "details": product.details,
                        "favorited": product.favorited,
                        "price": product.price,
                        "open_to_trade": product.open_to_trade,
                        "picture": product.picture,
                        "date_posted": product.date_posted,
                        "user": product.user
                    ]

                    var ref: DocumentReference? = nil

                    ref = db.collection("products").addDocument(data: productDict) { error in
                        if let error = error {
                            print("Error saving product: \(error.localizedDescription)")
                        } else {
                            print("Product successfully saved!")
                            
                            guard let documentID = ref?.documentID else { return }

                            // Now update the user's uploadedProductIDs array
                            self.updateUserUploadedProducts(userID: userID, productID: documentID)
                            // switch back to the Explore tab
                            self.selectedTab = 0 // Assuming Explore tab is at index 0
                            
//                            // Dismiss UploadProductPage view and navigate to ExplorePage
//                            self.presentationMode.wrappedValue.dismiss()
                        }

                    }
                } catch let error {
                    print("Error encoding product: \(error)")
                }
            }
        }
    func updateUserUploadedProducts(userID: String, productID: String) {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)

            userRef.updateData([
                "uploadedProductIDs": FieldValue.arrayUnion([productID])
            ]) { error in
                if let error = error {
                    print("Error updating user: \(error.localizedDescription)")
                } else {
                    print("User updated successfully.")
                }
            }
        }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photos")) {
                    HStack {
                        ForEach(0..<4, id: \.self) { index in
                            ZStack {
                                if index < images.count {
                                    Image(uiImage: images[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Rectangle())
                                        .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                                } else {
                                    Rectangle()
                                        .fill(Color.secondary)
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                }
                            }
                            .onTapGesture {
                                showingImagePicker = true
                            }
                        }
                    }
                }
                
                Section(header: Text("Title")) {
                    TextField("What are you selling?", text: $itemTitle)
                }
                
                Section(header: Text("Description")) {
                    TextField("Description of Item", text: $itemDescription)
                }
                
                Section(header: Text("Details")) {
                    TextField("Category", text: $category)
                    TextField("Brand", text: $brand)
                    TextField("Condition", text: $condition)
                }
                
                Section(header: Text("Price")) {
                    HStack {
                        TextField("$$", text: $price)
                            .keyboardType(.decimalPad)
                        Spacer()
                        // Getting rid of open to trade feature
                        // Toggle("Open to Trades?", isOn: $openToTrades)
                    }
                }
                
                Section {
                    Button("List Item") {
                        // Action to list the item
                        uploadImagesAndSaveProduct()
                    }
                }
            }
            .navigationBarTitle("Sell Your Item", displayMode: .inline)
            .sheet(isPresented: $showingImagePicker) {
                            MultipleImagePicker(images: $images)
                        }
        }
        .tabItem {
            Image(systemName: "camera.fill")
            Text("Sell")
        }
    }
}

struct MultipleImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 0  // 0 means no limit
        config.filter = .images    // We want to pick images only
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultipleImagePicker

        init(_ parent: MultipleImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}


struct ListingPage_Previews: PreviewProvider {
    static var previews: some View {
        UploadProductPage(selectedTab: .constant(0))
    }
}
