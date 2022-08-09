//
//  TaskFormController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-04.
//

import UIKit

class TaskFormController: UIViewController {
    
    // MARK: - Variables
    let viewModel: TaskFormControllerViewModel
    
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
//        tableView.register(TaskFormTextFieldCell.self, forCellReuseIdentifier: TaskFormTextFieldCell.identifier)
//        tableView.register(TaskFormDatePickerCell.self, forCellReuseIdentifier: TaskFormDatePickerCell.identifier)
//        tableView.register(TaskFormRepeatingCell.self, forCellReuseIdentifier: TaskFormRepeatingCell.identifier)
//        tableView.register(TaskFormNotificationCell.self, forCellReuseIdentifier: TaskFormNotificationCell.identifier)
        tableView.allowsSelection = true
        tableView.backgroundColor = .dynamicColorOne
        return tableView
    }()

    // MARK: - Lifecycle
    init(_ viewModel: TaskFormControllerViewModel) {
        self.viewModel = viewModel
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
        self.navigationItem.title = self.viewModel.navTitle
        view.backgroundColor = .dynamicColorOne
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.viewModel.saveButtonTitle, style: .done, target: self, action: #selector(didClickSave))
    }
    
    // MARK: - Selectors
    @objc private func didClickSave() {
        
    }
    
    
}
