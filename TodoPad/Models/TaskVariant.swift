//
//  TaskVariant.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-05.
//

import Foundation

protocol TaskVariant {
    var title: String { get }
    var desc: String? { get }
    var taskUUID: UUID { get }
    var isCompleted: Bool { get }
    var notificationsEnabled: Bool { get }
}
