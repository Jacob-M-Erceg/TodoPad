//
//  TaskCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-16.
//

import UIKit

class TaskCell: UITableViewCell {
    
    static let identifier = "TaskCell"
    
    // MARK: - UI Components
    private let colouredSideLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
//    private let taskIcon: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.image = UIImage(systemName: "questionmark.square")
//        iv.tintColor = .label
//        return iv
//    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.text = "Error"
        label.attributedText = nil
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with task: Task, _ isCompleted: Bool = false) {
        self.backgroundColor = .dynamicColorTwo
        
        switch task {
        case .persistent(_):
            self.timeLabel.text = nil
            
        case .repeating(let repeatingTask):
            self.timeLabel.text = repeatingTask.time?.timeString
            
        case .nonRepeating(let nonRepeatingTask):
            self.timeLabel.text = nonRepeatingTask.time?.timeString
        }
        
        if isCompleted {
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: task.title)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            self.taskLabel.attributedText = attributeString
//            self.colouredSideLine.backgroundColor = .systemGreen
        } else {
            self.taskLabel.attributedText = nil
            self.taskLabel.text = task.title
            self.colouredSideLine.backgroundColor = .systemBlue
        }
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        addSubview(colouredSideLine)
//        addSubview(taskIcon)
        
        colouredSideLine.translatesAutoresizingMaskIntoConstraints = false
//        taskIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [taskLabel, timeLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colouredSideLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            colouredSideLine.topAnchor.constraint(equalTo: topAnchor),
            colouredSideLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            colouredSideLine.widthAnchor.constraint(equalToConstant: 6),
            
//            taskIcon.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
//            taskIcon.leadingAnchor.constraint(equalTo: colouredSideLine.trailingAnchor, constant: 11),
//            taskIcon.heightAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor, multiplier: 0.65),
//            taskIcon.widthAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor, multiplier: 0.65),
//            stackView.leadingAnchor.constraint(equalTo: taskIcon.trailingAnchor, constant: 7),
            
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -4),
            stackView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
        ])
    }
}
