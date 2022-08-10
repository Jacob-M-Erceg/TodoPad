//
//  TaskFormNotificationCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-10.
//

import UIKit

class TaskFormNotificationCell: BaseTaskFormDropDownCell {
    
    static let identifier = "TaskFormNotificationCell"
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func configure(with taskFormCellModel: TaskFormCellModel) {
        super.configure(with: taskFormCellModel)
//        guard taskFormCellModel.isEnabled, taskFormCellModel.isExpanded else { return }
//        self.setupUI()
    }
//
//    // MARK: - UI Setup
//    private func setupUI() {
//        self.selectionStyle = .none
//        self.backgroundColor = .dynamicColorTwo
//
//
//        NSLayoutConstraint.activate([
//
//        ])
//    }
}
