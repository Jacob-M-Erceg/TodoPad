//
//  ViewTaskTableViewHeader.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-18.
//

import UIKit

protocol ViewTaskTableViewHeaderDelegate: AnyObject {
    func didTapCompleteTask()
}

class ViewTaskTableViewHeader: UICollectionReusableView {
    
    weak var delegate: ViewTaskTableViewHeaderDelegate?
    
    // MARK: - UI Components
    let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "Error"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Error"
        label.numberOfLines = 0
        return label
    }()
    
    let completeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 24
        button.setTitle("Complete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, title: String, description: String?, taskIsCompleted: Bool) {
        super.init(frame: frame)
        self.taskTitleLabel.text = title
        self.descriptionLabel.text = description
        self.completeButton.setTitle(taskIsCompleted ? "Undo" : "Complete", for: .normal)
        
        self.setupUI()
        self.completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .dynamicColorOne
        
        addSubview(taskTitleLabel)
        addSubview(descriptionLabel)
        addSubview(completeButton)
        
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            taskTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            taskTitleLabel.heightAnchor.constraint(equalToConstant: 35),
            
            descriptionLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            completeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            completeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            completeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            completeButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapComplete() {
        self.delegate?.didTapCompleteTask()
    }
    
}
