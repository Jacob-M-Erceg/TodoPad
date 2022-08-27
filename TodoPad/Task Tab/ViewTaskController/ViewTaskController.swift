//
//  ViewTaskController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-16.
//

import UIKit

class ViewTaskController: UIViewController, ViewTaskTableViewHeaderDelegate {
    
    var onTappedCompleteTask: (()->Void)?
    
    // MARK: - Variables
    let viewModel: ViewTaskControllerViewModel
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(NormalViewTaskCell.self, forCellReuseIdentifier: NormalViewTaskCell.identifier)
        tableView.register(RepeatSettingsViewTaskCell.self, forCellReuseIdentifier: RepeatSettingsViewTaskCell.identifier)
        tableView.separatorColor = .systemGray2
        tableView.backgroundColor = .dynamicColorOne
        return tableView
    }()
    
    // MARK: - Lifecycle
    init(viewModel: ViewTaskControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .dynamicColorOne
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let header = ViewTaskTableViewHeader(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.view.width,
                height:
                    28 + // Task Title Label Top Spacing
                35 + // Task Title Label Height
                16 + // Description Label Top Spacing
                getDescriptionLabelHeight() +
                40 + // Complete Button Top Spacing
                44 + // Complete Button Height
                40 // Complete Button Button Spacing
            ),
            title: self.viewModel.task.title,
            description: self.viewModel.task.desc,
            taskIsCompleted: self.viewModel.task.isCompleted
        )
        header.delegate = self
        tableView.tableHeaderView = header
    }
    
    private func getDescriptionLabelHeight() -> CGFloat {
        let taskDesc = self.viewModel.task.desc
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.width-24, height: .greatestFiniteMagnitude))
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = taskDesc
        label.numberOfLines = 0
        label.sizeToFit()
        return label.frame.height
    }
    
    func didTapCompleteTask() {
        HapticsManager.shared.vibrateForActionCompleted()
        self.onTappedCompleteTask?()
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - TableView Functions
extension ViewTaskController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewTaskCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // RepeatSettings Cell
        if let _ = self.viewModel.task.getRepeatingTask, indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RepeatSettingsViewTaskCell.identifier, for: indexPath) as? RepeatSettingsViewTaskCell else {
                fatalError("Failed to dequeue RepeatSettingsViewTaskCell in ViewTaskController.")
            }
            let image = self.viewModel.viewTaskCells[indexPath.row].image
            let title = self.viewModel.viewTaskCells[indexPath.row].title
            let weeklyArray: [Int]? = self.viewModel.viewTaskCells[indexPath.row].weeklyArray
            
            cell.configure(image: image, title: title, weekdayArray: weeklyArray)
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NormalViewTaskCell.identifier, for: indexPath) as? NormalViewTaskCell else {
                fatalError("Failed to dequeue NormalViewTaskCell in ViewTaskController.")
            }
            let image = self.viewModel.viewTaskCells[indexPath.row].image
            let title = self.viewModel.viewTaskCells[indexPath.row].title
            
            cell.configure(image: image, title: title)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Repeating Cell
        if let _ = self.viewModel.task.getRepeatingTask?.repeatSettings.getWeeklyArray, indexPath.row == 2 {
            return 122
        }
        // Normal Cell
        else {
            return 55
        }
    }
}
