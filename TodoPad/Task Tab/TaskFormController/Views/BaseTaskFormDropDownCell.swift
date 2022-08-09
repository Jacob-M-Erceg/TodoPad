//
//  BaseTaskFormDropDownCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-08.
//

import UIKit

protocol BaseTaskFormDropDownCellDelegate: AnyObject {
    func didChangeCellIsEnabled(taskFormCellModel: TaskFormCellModel, isEnabled: Bool)
}

/// Base Super Class for DropDown Task Form Cells
/// This is the Super Class for all cells besides TaskFormTextFieldCell
class BaseTaskFormDropDownCell: UITableViewCell {
    
    weak var baseDelegate: BaseTaskFormDropDownCellDelegate?
    
    private(set) var taskFormCellModel: TaskFormCellModel!
    
    
    // MARK: - UI Components
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark.square")
        iv.tintColor = .label
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Title"
        return label
    }()
    
    let onOffSwitch: UISwitch = {
        let onOffSwitch = UISwitch()
        onOffSwitch.isOn = false
        return onOffSwitch
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        onOffSwitch.addTarget(self, action: #selector(didTapOnOffSwitch), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with taskFormCellModel: TaskFormCellModel) {
        self.taskFormCellModel = taskFormCellModel
        self.clearViews()
        self.setupUI()
        
        self.iconImageView.image = taskFormCellModel.icon
        self.titleLabel.text = taskFormCellModel.title
        self.onOffSwitch.setOn(taskFormCellModel.isEnabled, animated: false)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .dynamicColorTwo
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(onOffSwitch)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        onOffSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant : (66/2)-(33/2)),
            iconImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 33),
            iconImageView.widthAnchor.constraint(equalToConstant: 33),
            
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            
            onOffSwitch.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            onOffSwitch.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
        ])
    }
    
    /// Selector to change if the cell is enabled or not
    @objc func didTapOnOffSwitch(mySwitch: UISwitch) {
        self.baseDelegate?.didChangeCellIsEnabled(taskFormCellModel: self.taskFormCellModel, isEnabled: mySwitch.isOn)
    }
    
    private func clearViews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
