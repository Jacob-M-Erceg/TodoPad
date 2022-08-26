//
//  StatsCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-26.
//

import UIKit

class StatsCell: UITableViewCell {
    
    static let identifier = "StatsCell"
    
    // MARK: - UI Components
    let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    let tasksCompletedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    let progressBar: ProgressBar = {
       let bar = ProgressBar()
        bar.trackTintColor = .customGray
        bar.progress = 0
        bar.progressTintColor = .systemBlue
        bar.roundedCorners(radius: 9)
        bar.setupUI()
        return bar
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(repeatingTaskStats: RepeatingTaskStats) {
        self.taskTitleLabel.text = repeatingTaskStats.repeatingTask.title
        self.tasksCompletedLabel.text = "\(repeatingTaskStats.daysCompleted)/\(repeatingTaskStats.daysSinceStarted) Days Completed"
        self.progressBar.progress = Float(repeatingTaskStats.daysCompleted)/Float(repeatingTaskStats.daysSinceStarted)

        guard repeatingTaskStats.daysSinceStarted > 0 else {
            self.progressBar.setProgressLabel(title: "0%")
            self.progressBar.progress = 0
            return
        }
        
        let percentage = ((Double(repeatingTaskStats.daysCompleted)/Double(repeatingTaskStats.daysSinceStarted)*100)).roundTo(decimalPlaces: 1)
        self.progressBar.setProgressLabel(title: percentage + "%")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .dynamicColorTwo
        
        self.addSubview(tasksCompletedLabel)
        self.addSubview(taskTitleLabel)
        self.addSubview(progressBar)
        
        tasksCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let topSeperator = UIView()
        topSeperator.backgroundColor = .systemGray
        self.addSubview(topSeperator)
        topSeperator.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = .systemGray
        self.addSubview(bottomSeperator)
        bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topSeperator.topAnchor.constraint(equalTo: topAnchor),
            topSeperator.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSeperator.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSeperator.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomSeperator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeperator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeperator.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeperator.heightAnchor.constraint(equalToConstant: 0.5),
            
            
            taskTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            taskTitleLabel.heightAnchor.constraint(equalToConstant: 23),
            taskTitleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            
            tasksCompletedLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 5),
            tasksCompletedLabel.heightAnchor.constraint(equalToConstant: 22),
            tasksCompletedLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            progressBar.heightAnchor.constraint(equalToConstant: 19),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            progressBar.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.progressBar.roundedCorners(radius: 9)
    }
}


class ProgressBar: UIProgressView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Error"
        return label
    }()
    
    public func setProgressLabel(title: String?) {
        self.label.text = title
    }
    
    public func setupUI() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    public func roundedCorners(radius: CGFloat) {
        for view in self.subviews {
            if view is UIImageView {
                view.clipsToBounds = true
                view.layer.cornerRadius = radius
            }
        }
    }
}
