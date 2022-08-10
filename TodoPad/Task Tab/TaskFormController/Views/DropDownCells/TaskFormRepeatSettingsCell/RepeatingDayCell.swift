//
//  RepeatingDayCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-10.
//

import UIKit

/// This CollectionView Cell is used for selecting/viewing which days of the week a weekly task repeats on
class RepeatingDayCell: UICollectionViewCell {
    
    static let identifier = "RepeatingDayCell"
    
    // MARK: - UI Components
    private(set) var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "E"
        return label
    }()
    
    // MARK: - Lifecycle
    public func configure(with day: String, and isDaySelected: Bool) {
        self.label.text = day
        self.setupUI()
        self.backgroundColor = isDaySelected ? .systemBlue : .clear
        self.label.textColor = isDaySelected ? .white : .label
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.height/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
