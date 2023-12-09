//
//  Constants.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 11/30/23.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct AppColor {
        static let darkBlue = Color(red: 4 / 255, green: 53 / 255, blue: 101 / 255)
        static let lightBlue = Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        static let yellow = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        static let customYellow = Color("F5CB5C")
        static let primaryBlack = Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255)
        static let secondaryBlack = Color(red: 70 / 255, green: 75 / 255, blue: 95 / 255)
        static let lightGrayColor = Color(red: 249 / 255, green: 249 / 255, blue: 249 / 255)
        static let primaryRed = Color(red: 203 / 255, green: 45 / 255, blue: 62 / 255)
        static let secondaryRed = Color(red: 239 / 255, green: 71 / 255, blue: 58 / 255)
        static let shadowColor = Color(red: 221 / 255, green: 221 / 255, blue: 221 / 255)
        static let lightGreen = Color(red: 232 / 255, green: 251 / 255, blue: 232 / 255)
    }
    
    struct AppFont {
        static let extraBoldFont = "HelveticaNeue-Bold"
        static let boldFont = "HelveticaNeue-Bold"
        static let semiBoldFont = "HelveticaNeue-Medium"
        static let regularFont = "HelveticaNeue"
        static let lightFont = "HelveticaNeue-Light"
    }
}
