//
//  AssetImageUploader.swift
//  columbiamarketplace
//
//  Created by Hanvit Choi on 12/3/23.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseStorage

class AssetImageUploader {

    // List of asset image names to upload
    private let assetImageNames: [String]

    // Initializer
    init(assetImageNames: [String]) {
        self.assetImageNames = assetImageNames
    }

    // Function to upload all images in the assets
    func uploadAllImages(completion: @escaping ([String]) -> Void) {
        var uploadedImageUrls: [String] = []
        let imageGroup = DispatchGroup()

        for imageName in assetImageNames {
            imageGroup.enter()
            uploadImageFromAssets(assetImageName: imageName) { result in
                switch result {
                case .success(let url):
                    uploadedImageUrls.append(url)
                case .failure(let error):
                    print("Error uploading image \(imageName): \(error)")
                }
                imageGroup.leave()
            }
        }

        imageGroup.notify(queue: .main) {
            completion(uploadedImageUrls)
        }
    }

    // Function to upload a single image from assets
    private func uploadImageFromAssets(assetImageName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = UIImage(named: assetImageName) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image not found in assets"])))
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to JPEG data"])))
            return
        }

        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("product_images/\(imageName).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }

                completion(.success(downloadURL.absoluteString))
            }
        }
    }
}


