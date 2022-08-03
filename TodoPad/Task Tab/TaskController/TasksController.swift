//
//  TasksController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class TasksController: UIViewController {
    
    // MARK: - UI Components
    
    
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
        
    }
}
