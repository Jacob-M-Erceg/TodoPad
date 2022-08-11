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
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(TaskFormTextFieldCell.self, forCellReuseIdentifier: TaskFormTextFieldCell.identifier)
        tableView.register(TaskFormDatePickerCell.self, forCellReuseIdentifier: TaskFormDatePickerCell.identifier)
        tableView.register(TaskFormRepeatSettingsCell.self, forCellReuseIdentifier: TaskFormRepeatSettingsCell.identifier)
        tableView.register(TaskFormNotificationCell.self, forCellReuseIdentifier: TaskFormNotificationCell.identifier)
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
        
        //        self.viewModel.onUpdate = { [weak self] in
        //            DispatchQueue.main.async { [weak self] in
        //                self?.tableView.reloadData()
        //            }
        //        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.title = self.viewModel.navTitle
        view.backgroundColor = .dynamicColorOne
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.viewModel.saveButtonTitle, style: .done, target: self, action: #selector(didClickSave))
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc private func didClickSave() {
        
    }
}


// MARK: - TableView Functions
extension TaskFormController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.taskFormCellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.viewModel.taskFormCellModels[section].count
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskFormCellModel = self.viewModel.taskFormCellModels[indexPath.section][indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskFormTextFieldCell.identifier, for: indexPath) as? TaskFormTextFieldCell else {
            fatalError("TaskFormTextFieldCell failed to dequeue in TaskFormController.")
        }
        
        if taskFormCellModel.cellType == .title {
            cell.configure(with: taskFormCellModel, textFieldText: self.viewModel.taskFormModel.title)
        }
        else if taskFormCellModel.cellType == .description {
            cell.configure(with: taskFormCellModel, textFieldText: self.viewModel.taskFormModel.description)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let taskFormCellModel = self.viewModel.taskFormCellModels[indexPath.section][indexPath.row]
        
        if taskFormCellModel.isEnabled && taskFormCellModel.isExpanded {
            switch taskFormCellModel.cellType {
                case .title, .description: return 66
                case .startDate, .time, .endDate: return 66 + 55
                case .repeats: return 66 + 44 + 122
                case .notifications: return 66
            }
        }
        else {
            return 66
        }
    }
    
    
}
