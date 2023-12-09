//
//  User.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 11/15/23.
//


//import Foundation
//
//struct User: Identifiable, Codable {
//    let id: String
//    let fullname: String
//    let uni: String
//    let email: String
//
//    var initials: String {
//        let formatter = PersonNameComponentsFormatter()
//        if let components = formatter.personNameComponents(from: fullname) {
//            formatter.style = .abbreviated
//            return formatter.string(from:components)
//        }
//        return ""
//    }
//
//}
//
//extension User {
//    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Bob Jones", uni: "bbj1202", email: "test@gmail.com")
//}
// data model for users

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let uni: String
    let email: String
    var likes: [String]
    var uploadedProductIDs: [String] = []
    

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(
        id: "iw6XCKvSgQaTJux3NKIE1xVryYl2",
        fullname: "Perry Platypus",
        uni: "Ppt2424",
        email: "testing123@gmail.com",
        likes: ["0xqNCWrzCX0tkh12gbzv"],
        uploadedProductIDs: ["SeF1G5jc5dv29gPtz97M"]
    )
}
