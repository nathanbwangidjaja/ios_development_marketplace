
 //
 //  ProductRow.swift
 //  columbiamarketplace
 //
 //  Created by Nathan Wangidjaja on 12/1/23.
 //

import SwiftUI
import FirebaseFirestore


 struct ProductRow: View {
     @EnvironmentObject var cartManager: CartManager
     var product: FirebaseProduct
     var body: some View {
         HStack(spacing: 20) {
             /*
             Image(product.picture)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width:50)
                 .cornerRadius(10)
              */
             if let imageUrlString = product.picture.first, let imageUrl = URL(string: imageUrlString) {
                 AsyncImageView(url: imageUrl)
                     .frame(height: 100)
                     .frame(width:100)
                     .cornerRadius(10)
             } else {
                 // Placeholder image or view
                 Color.gray.frame(height: 200).cornerRadius(10)
             }
             
             VStack(alignment: .leading, spacing: 10) {
                 Text(product.name)
                     .bold()
                 Text("$\(String(format: "%.2f", product.price))")
             }
             
             Spacer()
             
             Image(systemName: "trash")
                 .foregroundColor(Color(hue:1.0, saturation: 0.89, brightness: 0.835))
                 .onTapGesture {
                     cartManager.removeFromCart(product: product)
                 }
         }
         .padding(.horizontal)
         .frame(maxWidth: .infinity, alignment: .leading)
     }
 }

 struct ProductRow_Previews: PreviewProvider {
     static var previews: some View {
         let timestampValue = 1701480647.5
         let firestoreTimestamp = Timestamp(seconds: Int64(timestampValue), nanoseconds: 0)
         let mockProduct = FirebaseProduct(id: "0xqNCWrzCX0tkh12gbzv", date_posted: firestoreTimestamp, details: "", favorited: false, name: "handbag", open_to_trade: true, picture: ["https://firebasestorage.googleapis.com:443/v0/b/columbiamarketplace-b3ad3.appspot.com/o/product_images%2F9A1AD741-C286-49ED-93C0-B1BD54E06DD0.jpg?alt=media&token=7604107d-ac66-4340-a7c5-7b1a1a5b5b10"], price: 40, user: "MRLg8bok7NZoWMRJPB4kqtTkYZc2")
         
         ProductRow(product: mockProduct)
             //.environmentObject(CartManager())
     }
 }

/*
 
 var date_posted: Timestamp
 var details: String
 var favorited: Bool
 var name: String
 var open_to_trade: Bool
 var picture: String
 var price: Double
 var user: String
 */
