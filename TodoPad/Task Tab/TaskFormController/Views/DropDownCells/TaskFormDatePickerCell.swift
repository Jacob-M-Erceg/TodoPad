//
//  TaskFormDatePickerCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-08.
//

import UIKit

protocol TaskFormDatePickerCellDelegate: AnyObject {
    func didEditDatePicker(_ taskFormCellModel: TaskFormCellModel, _ date: Date)
}

/// Task Form Cell for UIDatePicker & UITimePicker Cells
class TaskFormDatePickerCell: BaseTaskFormDropDownCell {
    
    static let identifier = "TaskFormDatePickerCell"
    
    weak var delegate: TaskFormDatePickerCellDelegate?
    
    // MARK: - UI Components
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.isEnabled = true
        picker.timeZone = .current
        return picker
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        datePicker.addTarget(self, action: #selector(datePickerChange(picker:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with taskFormCellModel: TaskFormCellModel, and taskFormModel: TaskFormModel) {
        super.configure(with: taskFormCellModel)
        guard taskFormCellModel.isEnabled, taskFormCellModel.isExpanded else { return }
        self.setupUI()
        
        switch taskFormCellModel.cellType {
        case .title, .description, .repeats, .notifications:
            return
            
        case .startDate:
            if let startDate = taskFormModel.startDate {
                self.datePicker.datePickerMode = .date
                self.datePicker.date = startDate
            }
            
        case .endDate:
            if let endDate = taskFormModel.endDate {
                self.datePicker.datePickerMode = .date
                self.datePicker.date = endDate
            }
        case .time:
            if let time = taskFormModel.time {
                self.datePicker.datePickerMode = .time
                self.datePicker.date = time
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .dynamicColorTwo
        
        self.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: self.iconImageView.bottomAnchor),
            datePicker.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Selectors
    @objc func datePickerChange(picker: UIDatePicker) {
        self.delegate?.didEditDatePicker(self.taskFormCellModel, picker.date)
    }
}
