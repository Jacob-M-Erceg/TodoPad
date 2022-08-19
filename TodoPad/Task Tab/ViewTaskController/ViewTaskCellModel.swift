//
//  ViewTaskCellModel.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-18.
//

import UIKit

struct ViewTaskCellModel {
    let title: String
    let image: UIImage?
    let weeklyArray: [Int]?
    
    init(title: String, image: UIImage?, weeklyArray: [Int]? = nil) {
        self.title = title
        self.image = image
        self.weeklyArray = weeklyArray
    }
}
