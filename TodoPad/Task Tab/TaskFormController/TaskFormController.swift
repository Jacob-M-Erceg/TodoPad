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
    
    var onCompleted: (() -> Void)?
    
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
        
        self.viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        
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
        if let task = self.viewModel.validateTaskFormModel(with: self.viewModel.taskFormModel) {
            switch self.viewModel.taskFormMode {
            case .newTask:
                self.saveNewTask(task: task)
            case .editTask:
                if self.illegalExistingTaskChange(task: task) { return }
                self.editExistingTask(task: task)
            }
            
            if let originalTask = self.viewModel.originalTask, originalTask.notificationsEnabled == true {
                NotificationManager.removeNotifications(for: task)
            }
            
            if task.notificationsEnabled {
                NotificationManager.setNotification(for: task)
            }
            
            self.navigationController?.popViewController(animated: true)
            self.onCompleted?()
        }
    }
    
    private func saveNewTask(task: Task) {
        self.viewModel.saveNewTask(task: task)
    }
    
    private func editExistingTask(task: Task) {
        self.viewModel.editExistingTask(task: task)
    }
    
    private func illegalExistingTaskChange(task: Task) -> Bool {
        guard let originalTask = self.viewModel.originalTask else { return true }
        
        // If task enum type is not the same
        if !(originalTask ~= task) {
            AlertManager.showCannotEditTaskTypeErrorAlert(
                on: self,
                firstTaskType: self.viewModel.originalTask!.typeOfTask,
                secondTaskType: task.typeOfTask
            )
            return true
        }
        
        return false
    }
}


// MARK: - TableView Functions
extension TaskFormController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.taskFormCellModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.taskFormCellModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskFormCellModel = self.viewModel.taskFormCellModels[indexPath.section][indexPath.row]
        
        switch taskFormCellModel.cellType {
        case .title, .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskFormTextFieldCell.identifier, for: indexPath) as? TaskFormTextFieldCell else {
                fatalError("TaskFormTextFieldCell failed to dequeue in TaskFormController.")
            }
            
            if taskFormCellModel.cellType == .title {
                cell.configure(with: taskFormCellModel, textFieldText: self.viewModel.taskFormModel.title)
            }
            else if taskFormCellModel.cellType == .description {
                cell.configure(with: taskFormCellModel, textFieldText: self.viewModel.taskFormModel.description)
            }
            cell.delegate = self
            return cell
            
        case .startDate, .time, .endDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskFormDatePickerCell.identifier, for: indexPath) as? TaskFormDatePickerCell else {
                fatalError("TaskFormDatePickerCell failed to dequeue in TaskFormController.")
            }
            
            cell.configure(with: taskFormCellModel, and: self.viewModel.taskFormModel)
            cell.baseDelegate = self
            cell.delegate = self
            return cell
            
        case .repeats:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskFormRepeatSettingsCell.identifier, for: indexPath) as? TaskFormRepeatSettingsCell else {
                fatalError("TaskFormRepeatingCell failed to dequeue in TaskFormController.")
            }
            
            cell.configure(with: taskFormCellModel, and: self.viewModel.taskFormModel.repeatSettings ?? RepeatSettings.daily)
            cell.baseDelegate = self
            cell.delegate = self
            
            return cell
            
        case .notifications:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskFormNotificationCell.identifier, for: indexPath) as? TaskFormNotificationCell else {
                fatalError("TaskFormNotificationCell failed to dequeue in TaskFormController.")
            }
            cell.configure(with: taskFormCellModel)
            cell.baseDelegate = self
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let taskFormCellModel = self.viewModel.taskFormCellModels[indexPath.section][indexPath.row]
        guard taskFormCellModel.isEnabled, taskFormCellModel.cellType.isExpandable else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.invertIsExpanded(indexPath)
        }
    }
}

// MARK: - TaskCell Delegate Functions
extension TaskFormController: BaseTaskFormDropDownCellDelegate,
                              TaskFormTextFieldCellDelegate,
                              TaskFormDatePickerCellDelegate,
                              TaskFormRepeatSettingsCellDelegate {
    
    // BaseTaskFormDropDownCellDelegate
    func didChangeCellIsEnabled(taskFormCellModel: TaskFormCellModel, isEnabled: Bool) {
        self.viewModel.didChangeCellIsEnabled(taskFormCellModel, isEnabled: isEnabled)
    }
    
    // TaskFormTextFieldCellDelegate
    func didEditTextField(_ taskFormCellModel: TaskFormCellModel, _ text: String?) {
        self.viewModel.updateTaskFormModelForTextField(taskFormCellModel, text)
    }
    
    // TaskFormDatePickerCellDelegate
    func didEditDatePicker(_ taskFormCellModel: TaskFormCellModel, _ date: Date) {
        self.viewModel.updateTaskFormModelForDate(taskFormCellModel, date)
    }
    
    // TaskFormRepeatingCellDelegate
    func didChangeRepeatSettings(_ repeatSettings: RepeatSettings) {
        self.viewModel.updateTaskFormModelForRepeatSettings(repeatSettings)
    }
}
