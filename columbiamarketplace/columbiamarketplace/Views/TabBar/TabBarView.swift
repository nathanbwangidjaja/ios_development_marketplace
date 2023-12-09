//
//  TabBarView.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 11/30/23.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selected = 0

    var body: some View {
        TabView(selection: $selected) {
            NavigationView {
                ExplorePage()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            NavigationView {
                MessagePage()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Message")
            }
            .tag(1)

//            NavigationView {
//                // Replace with your BagView content
//                Text("Cart Content")
//                    .navigationBarTitle("", displayMode: .inline)
//                    .navigationBarHidden(true)
//            }
//            .tabItem {
//                Image(systemName: "bag.fill")
//                Text("Cart")
//            }
//            .tag(3)

            NavigationView {
                            UploadProductPage(selectedTab: $selected) // Pass the selected tab binding
                                .navigationBarTitle("", displayMode: .inline)
                                .navigationBarHidden(true)
                        }
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("Upload")
                        }
                        .tag(2)
            
            NavigationView {
                FavoritesView()
                    //.environmentObject(FavoritesManager())
                //Text("Favorites")
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorite")
            }
            .tag(3)
            
            NavigationView {
                ProfileView()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(4)
            
            
            
        }
        .accentColor(Constants.AppColor.darkBlue)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(FavoritesManager())
    }
}


