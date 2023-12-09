//
//  AsyncImageView.swift
//  columbiamarketplace
//
//  Created by Hanvit Choi on 12/2/23.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL
    @State private var imageData: Data?
    
    var body: some View {
        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                // Placeholder view or a loading indicator
                Color.gray
            }
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
            // Handle errors or add additional logic if needed
        }.resume()
    }
}
