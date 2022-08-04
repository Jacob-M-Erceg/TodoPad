//
//  UILabel+Extensions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

extension UILabel {
    
    static func createDateScrollerSubLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }
}
