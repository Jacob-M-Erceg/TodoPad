//
//  DateScrollerCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class DateScrollerCell: UICollectionViewCell {
    
    static let identifier = "DateScrollerCell"
    
    // MARK: - Variables
    private(set) var date: Date!
    
    
    // MARK: - UI Components
    private(set) var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "-1"
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
    
    public func configure(with date: Date) {
        self.date = date
        let day = Calendar.current.dateComponents([.day], from: date).day
        self.dayLabel.text = day!.description
    }
    
    public func setSelection(with selectedDate: Date) {
        let selected = DateHelper.isSameDay(selectedDate, self.date)
        
        self.backgroundColor = selected ? .systemBlue : .dynamicColorOne
        
        if DateHelper.isToday(self.date) {
            self.dayLabel.textColor = selected ? .white : .systemBlue
        } else {
            self.dayLabel.textColor = selected ? .white : .label
        }
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.layer.cornerRadius = self.height/2

        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
