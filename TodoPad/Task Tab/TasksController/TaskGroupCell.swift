//
//  TaskGroupCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-11.
//

import UIKit

protocol TaskGroupCellDelegate: AnyObject {
    /// Callback to open or close the task group
    func didTapTaskGroupCell(for taskGroup: TaskGroup)
}

class TaskGroupCell: UITableViewHeaderFooterView {
    
    static let identifier = "TaskGroupCell"
    
    weak var delegate: TaskGroupCellDelegate?

    // MARK: - Variables
    var taskGroup: TaskGroup!
    
    //  MARK: - UI Components
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        return iv
    }()
    
    // MARK: - Lifecycle Functions
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with taskGroup: TaskGroup) {
        self.taskGroup = taskGroup
        
        self.label.text = self.taskGroup.title
        
        if self.taskGroup.isOpened {
            self.imageView.image = UIImage(systemName: "chevron.down")
        } else {
            self.imageView.image = UIImage(systemName: "chevron.up")
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .dynamicColorThree
        self.backgroundView = backgroundView
        
        addSubview(label)
        addSubview(imageView)
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -9),
            imageView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 9),
            label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -4),
            label.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor),
            label.heightAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        self.addGestureRecognizer(gesture)
        
    }
    
    // MARK: - Selectors
    @objc func didTapHeader() {
//        self.cellFlashAnimation()
        
        if self.taskGroup.isOpened {
            self.imageView.image = UIImage(systemName: "chevron.up")
        } else {
            self.imageView.image = UIImage(systemName: "chevron.down")
        }
        
        self.delegate?.didTapTaskGroupCell(for: self.taskGroup)
    }
}

/*
 private func cellFlashAnimation() {
     UIView.animate(withDuration: 0.2) { [weak self] in
         self?.contentView.backgroundColor = .systemGray5
         
     } completion: { [weak self] _ in
         UIView.animate(withDuration: 0.2) { [weak self] in
             self?.contentView.backgroundColor = .dynamicColorThree
         }
     }
 }
 */
