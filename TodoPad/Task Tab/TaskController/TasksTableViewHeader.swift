//
//  TasksTableViewHeader.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-03.
//

import UIKit

protocol TasksTableViewHeaderDelegate: AnyObject {
    func didTapAddNewTask()
}

class TasksTableViewHeader: UICollectionReusableView {
    
    weak var delegate: TasksTableViewHeaderDelegate!
    
    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Tasks"
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "addNewTaskButton"
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 17
        button.setTitle("Add New", for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .dynamicColorOne
        
        addSubview(label)
        addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 22),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
//            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 32),
            button.widthAnchor.constraint(equalToConstant: 92),
            button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -22),
            button.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapAddButton() {
        self.delegate.didTapAddNewTask()
    }
}
