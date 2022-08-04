//
//  TasksController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class TasksController: UIViewController {
    
    // MARK: - UI Components
    let dateScroller: DateScroller = DateScroller()
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .dynamicColorOne
        
        view.addSubview(dateScroller)
        
        dateScroller.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateScroller.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            dateScroller.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            dateScroller.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            dateScroller.heightAnchor.constraint(equalToConstant: 88),
            
        ])
    }
    
}
