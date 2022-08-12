//
//  TaskGroup.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

struct TaskGroup {
    let title: String
    var isOpened: Bool = true
    var tasks: [Task] = []
}
