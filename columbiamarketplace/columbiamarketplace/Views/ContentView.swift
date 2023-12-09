//
//  ContentView.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 11/14/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabBarView()
                    //.environmentObject(FavoritesManager())
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .environmentObject(FavoritesManager())
    }
}
