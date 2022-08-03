//
//  UINavigationController+Extensions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

extension UINavigationController {
    
    func setupNavBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .dynamicColorTwo
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
}
