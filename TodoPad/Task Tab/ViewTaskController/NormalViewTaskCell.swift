//
//  NormalViewTaskCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-18.
//

import UIKit

class NormalViewTaskCell: UITableViewCell {
    
    static let identifier = "NormalViewTaskCell"
    
    // MARK: - UI Components
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        iv.image = UIImage(systemName: "questionmark.square")?.withTintColor(.label, renderingMode: .alwaysOriginal)
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
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(image: UIImage?, title: String) {
        self.iconImageView.image = image?.withTintColor(.label, renderingMode: .alwaysOriginal)
        self.titleLabel.text = title
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .dynamicColorTwo
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
