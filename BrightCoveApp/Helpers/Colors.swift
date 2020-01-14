//
//  Colors.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 16/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit
enum ApplicationColors{
    static let primary_colour = 0xFE5E00
    static let rimary_dark_colour = 0xE64A19
    static let accent_colour = 0xFFCCBC
    static let white = 0xFFFFFF
    static let black = 0x000000
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hexa: Int) {
       self.init(
           red: (hexa >> 16) & 0xFF,
           green: (hexa >> 8) & 0xFF,
           blue: hexa & 0xFF
       )
   }
}
