//
//  RepeatSettingsViewTaskCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-18.
//

import UIKit

class RepeatSettingsViewTaskCell: UITableViewCell {
    
    static let identifier = "RepeatSettingsViewTaskCell"
    
    var weekdayArray: [Int]?

    // MARK: - UI Components
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.image = UIImage(systemName: "questionmark.square")?.withTintColor(.label, renderingMode: .automatic)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .dynamicColorTwo
        collectionView.register(RepeatingDayCell.self, forCellWithReuseIdentifier: RepeatingDayCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(image: UIImage?, title: String, weekdayArray: [Int]?) {
        self.iconImageView.image = image
        self.titleLabel.text = title
        self.weekdayArray = weekdayArray
        
        self.setupUI()
    }
     
    // MARK: - UI Setup
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .dynamicColorTwo
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if self.weekdayArray == nil {
            NSLayoutConstraint.activate([
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 32),
                iconImageView.heightAnchor.constraint(equalToConstant: 32),
                
                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        } else {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            self.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                iconImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 32),
                iconImageView.heightAnchor.constraint(equalToConstant: 32),
                
                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
              
                collectionView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - CollectionView Functions
extension RepeatSettingsViewTaskCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepeatingDayCell.identifier, for: indexPath) as? RepeatingDayCell else {
            fatalError("Failed to dequeue RepeatingDayCell in TaskFormRepeatingCell")
        }

        if let weekdayArray = self.weekdayArray {
            let isDaySelected = weekdayArray.contains(indexPath.row+1)
            cell.configure(with: Constants.weekdayLettersArray[indexPath.row], and: isDaySelected)
        }

        return cell
    }
    
    // TODO - Write tests for this function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.width < ((41*7)+(10*6)) {
            return CGSize(width: 32, height: 32)
        }
        return CGSize(width: 41, height: 41)
    }
    
    // TODO - Write tests for this function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var cellWidth: CGFloat = 41
        let spacingWidth: CGFloat = 10

        if self.width < ((41*7)+(10*6)) {
            cellWidth = 32
        }

        let totalCellWidth: CGFloat = cellWidth * 7
        let totalSpacingWidth: CGFloat = spacingWidth * 6

        let leftInset = (self.collectionView.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        let topInset = (self.collectionView.height - CGFloat(cellWidth)) / 2
        let bottomInset = topInset

        return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
