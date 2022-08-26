//
//  TaskCompletedPopup.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-23.
//

import UIKit

class TaskCompletedPopup: UIView {
    
    // MARK: - UI Components
    private let flameImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "flame.fill")//?.withTintColor(.systemOrange, renderingMode: .automatic)
        iv.tintColor = .systemOrange
        return iv
    }()
    
    let tasksCompletedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "-1 Tasks Completed"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(tasksCompleted: Int) {
        self.tasksCompletedLabel.text = "\(tasksCompleted) Tasks Completed"
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.layer.cornerRadius = 21
        self.backgroundColor = .rgb(red: 119, green: 58, blue: 58, alpha: 1)
        
        self.addSubview(flameImageView)
        self.addSubview(tasksCompletedLabel)

        flameImageView.translatesAutoresizingMaskIntoConstraints = false
        tasksCompletedLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            flameImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            flameImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            flameImageView.widthAnchor.constraint(equalToConstant: 44),
            flameImageView.heightAnchor.constraint(equalToConstant: 44),

            tasksCompletedLabel.leadingAnchor.constraint(equalTo: flameImageView.trailingAnchor),
            tasksCompletedLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            tasksCompletedLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
