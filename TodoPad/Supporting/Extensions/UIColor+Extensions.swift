//
//  UIColor+Extensions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return light
        }
        return UIColor {
            $0.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIColor {
    
    static let dynamicColorOne: UIColor = dynamicColor(
        light: .rgb(red: 242, green: 242, blue: 247, alpha: 1),
        dark: .rgb(red: 33, green: 33, blue: 33, alpha: 1)
    )
    
    static let dynamicColorTwo: UIColor = dynamicColor(
        light: .rgb(red: 255, green: 255, blue: 255, alpha: 1),
        dark: .rgb(red: 23, green: 23, blue: 23, alpha: 1)
    )
    
    static let dynamicColorThree: UIColor = dynamicColor(
        light: .rgb(red: 255, green: 255, blue: 255, alpha: 1),
        dark: .rgb(red: 16, green: 16, blue: 16, alpha: 1)
    )
}
