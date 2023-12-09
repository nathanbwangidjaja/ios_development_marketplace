//
//  ProfileView.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 11/27/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var cartManager = CartManager()
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                VStack {
                    HStack {
                        
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width:72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.headline)
                            Text(user.email)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            HStack(spacing: 4) {
                                Button{
                                    viewModel.signOut()
                                } label: {
                                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                                }
                                               
                            }
                            .frame(width: 200, alignment: .leading)
                        }
                        .frame(width: 250)
                        .clipped()
                    }
                    .padding(.top, 30)
                    
                    HStack {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            Text("Currently Listed")
                                .font(.custom("Helvetica", size: 20))
                                .foregroundColor(.black)
                            
                        }
                        
                    }
                    .foregroundColor(.secondary)
                    .font(.title2)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 2)
                    
                    // uploaded items in a grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)], spacing: 1) {
                        ForEach(viewModel.userProducts) { product in
                            NavigationLink(
                                destination: ProductDetailsView(product: product)
                                    .environmentObject(cartManager)
                                
                            ) {
                                VStack {
                                    // Display the first image URL as a string
                                    if let firstImageUrl = product.picture.first, let url = URL(string: firstImageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                                        .aspectRatio(1/1, contentMode: .fit)
                                        .clipped()
                                        .border(Color.black, width: 1) // Adding a black border
                                    } else {
                                        Text("No Image URL")
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                                            .aspectRatio(1/1, contentMode: .fit)
                                            .clipped()
                                            .border(Color.black, width: 1) // Adding a black border for consistency
                                    }
                                }
                            }
                        }
                    }

                    .onAppear {
                        Task {
                            await viewModel.fetchUserProducts(for: user)
                        }
                    }
                    
                    Spacer()
                    
                }
            }
        }
    }
}
        
        struct ProfileView_Previews: PreviewProvider {
            static var previews: some View {
                ProfileView()
                    .environmentObject(AuthViewModel())
            }
        }
        

