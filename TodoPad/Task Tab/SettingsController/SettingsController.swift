//
//  SettingsController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-22.
//

import UIKit

// TODO - Test This Class
class SettingsController: UIViewController {
    
    var refreshTasks: (()->Void)?
    
    // MARK: - Variables
    lazy private(set) var cells = [
        [
            SettingsCellModel(title: "Terms & Conditions", handler: { [weak self] in
                let vc = WebViewerController(with: Constants.termsAndConditions)
                self?.navigationController?.pushViewController(vc, animated: true)
            }),
            SettingsCellModel(title: "Privacy Policy", handler: { [weak self] in
                let vc = WebViewerController(with: Constants.privacyPolicy)
                self?.navigationController?.pushViewController(vc, animated: true)
            }),
        ],
        [
            SettingsCellModel(title: "Delete All Notifications", handler: { [weak self] in
                guard let self = self else { return }
                AlertManager.showDeleteAllNotificationskWarning(on: self) { deleted in
                    if deleted {
                        HapticsManager.shared.vibrateForActionCompleted()
                        
                        NotificationManager.removeAllNotifications()
                    } else {
                        HapticsManager.shared.vibrateForSelection()
                    }
                }
            }),
            SettingsCellModel(title: "Delete All Tasks", handler: { [weak self] in
                guard let self = self else { return }
                AlertManager.showDeleteAllTaskskWarning(on: self) { deleted in
                    if deleted {
                        HapticsManager.shared.vibrateForActionCompleted()
                        
                        PersistentTaskManager().deleteAllPersistentTasks()
                        RepeatingTaskManager().deleteAllRepeatingTasks()
                        NonRepeatingTaskManager().deleteAllNonRepeatingTasks()
                        self.refreshTasks?()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        HapticsManager.shared.vibrateForSelection()
                    }
                }
            }),
        ]
    ]
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .dynamicColorOne
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .dynamicColorOne
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.cells[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        self.cells[indexPath.section][indexPath.row].handler()
    }
}
