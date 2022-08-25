//
//  StatsTableViewHeader.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-25.
//

import UIKit

class StatsTableViewHeader: UICollectionReusableView {
    
    // MARK: - UI Components
    var shapeLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    
    let levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Error"
        return label
    }()
    
    let tasksCompletedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .dynamicColorOneGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Error"
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
    
    public func configure(level: Level) {
        self.levelLabel.text = level.levelString
        self.tasksCompletedLabel.text = "\(level.tasksCompleted)/\(level.nextLevel)\nTasks Completed"
        
        let lvlRatio = CGFloat(level.tasksCompleted)/CGFloat(level.nextLevel)
        self.setProgressBar(with: lvlRatio)
    }
    
    private func setProgressBar(with percentage: CGFloat) {
        self.shapeLayer.strokeEnd = percentage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupUI()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .dynamicColorOne
        
        self.trackLayer.createCircleShapeLayer(strokeColor: .circularProgressBarDynamicColor, fillColor: .clear, view: self)
        self.shapeLayer.createCircleShapeLayer(strokeColor: .systemBlue, fillColor: .clear, view: self)
        
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
        
        self.trackLayer.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        self.shapeLayer.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        self.shapeLayer.transform = CATransform3DMakeRotation((CGFloat.pi/2)*2, 0, 0, 1)
        
        self.addSubview(levelLabel)
        self.addSubview(tasksCompletedLabel)
        
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        tasksCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            levelLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            levelLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -29),
            
            tasksCompletedLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tasksCompletedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 22),
        ])
    }
}
