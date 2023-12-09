//
//  profile.swift
//  columbiamarketplace
//
//  Created by Nathan Wangidjaja on 11/14/23.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image("user")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipped()
                        .mask { RoundedRectangle(cornerRadius: 70, style: .continuous) }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bob Jones")
                            .font(.headline)
                        Text("Hey there, I’m using Columbia Marketplace!")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 4) {
                            VStack {
                                Text("5")
                                    .font(.system(.headline, weight: .semibold))
                                Text("Past Orders")
                                    .font(.footnote)
                            }
                            .frame(width: 80, alignment: .center)
                            VStack {
                                Text("4")
                                    .font(.system(.headline, weight: .semibold))
                                Text("Listings")
                                    .font(.footnote)
                            }
                            .frame(width: 80, alignment: .center)
                        }
                        .padding()
                    }
                    .frame(width: 250)
                    .clipped()
                }
                .padding(.top, 20)
                HStack {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        Text("Currently Listed")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Text("Past Orders")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                .foregroundColor(.secondary)
                .font(.title2)
                .padding(.top, 40)
                .padding(.bottom, 8)
                .padding(.horizontal, 4)
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)], spacing: 1) {
                        Image("shirt")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .aspectRatio(1/1, contentMode: .fit)
                            .clipped()
                        Image("bag")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .aspectRatio(1/1, contentMode: .fit)
                            .clipped()
                        Image("pants")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .aspectRatio(1/1, contentMode: .fit)
                            .clipped()
                        Image("hoodie")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .aspectRatio(1/1, contentMode: .fit)
                            .clipped()
                }
            }
            .frame(maxWidth: .infinity)
            .clipped()
            .padding(.top, 20)
            .padding(.bottom, 150)
        }
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
