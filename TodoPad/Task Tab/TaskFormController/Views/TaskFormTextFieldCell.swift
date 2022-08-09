//
//  TaskFormTextFieldCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-08.
//

import UIKit

protocol TaskFormTextFieldCellDelegate: AnyObject {
    func didEditTextField(_ taskFormCellModel: TaskFormCellModel, _ text: String?)
}

class TaskFormTextFieldCell: UITableViewCell {
    
    static let identifier = "TaskFormTextFieldCell"
    
    weak var delegate: TaskFormTextFieldCellDelegate?
    
    private(set) var taskFormCellModel: TaskFormCellModel!
    
    
    // MARK: - UI Components
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Textfield"
        tf.font = .systemFont(ofSize: 20, weight: .medium)
        tf.textColor = .label
        tf.autocorrectionType = .no
        return tf
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with taskFormCellModel: TaskFormCellModel, textFieldText: String?) {
        self.textField.text = textFieldText
        self.taskFormCellModel = taskFormCellModel
        self.setupUI()
        self.textField.placeholder = taskFormCellModel.title
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.backgroundColor = .dynamicColorTwo
        self.selectionStyle = .none
        
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}


// MARK: - TextField Fucntions
extension TaskFormTextFieldCell: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.delegate?.didEditTextField(self.taskFormCellModel, textField.text)
    }
}

