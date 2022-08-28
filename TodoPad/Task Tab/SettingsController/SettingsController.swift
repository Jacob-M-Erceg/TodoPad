//
//  SettingsController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-22.
//

import UIKit
import MessageUI

// TODO - Test This Class
class SettingsController: UIViewController {
    
    var refreshTasks: (()->Void)?
    
    // MARK: - Variables
    lazy private(set) var cells = [
        [
            SettingsCellModel(title: "Rate App", handler: { [weak self] in
                guard let self = self else { return }
                
                AlertManager.showRateAppAlertPrompt(on: self) { [weak self] showRateApp in
                    if showRateApp {
                        guard let self = self else { return }
                        AppReviewRequest.requestReviewIfNeeded(with: self)
                    } else {
                        let email = Constants.supportEmail
                        let subject = "App Improvment Suggestion"
                        let body = "Please leave some app improvement suggestions below: \n\n"
                        self?.showMailComposer(with: email, and: subject, and: body)
                        return
                    }
                }
            }),
            SettingsCellModel(title: "Share App", handler: { [weak self] in
                self?.presentShareSheet()
            })
        ],
        [
            SettingsCellModel(title: "Report Bug", handler: { [weak self] in
                guard let self = self else { return }
                
                AlertManager.showDetailedReportAlert(on: self) { [weak self] in
                    let email = Constants.supportEmail
                    let subject = "Bug Report"
                    let body = "Please fill out as many details as possible.... \n\n"
                    + "iPhone Model:  \n"
                    + "iOS Version: \n"
                    + "Desription of Bug: \n"
                    + "Anything else: "
                    self?.showMailComposer(with: email, and: subject, and: body)
                }
            }),
            SettingsCellModel(title: "Feature Suggestion", handler: { [weak self] in
                
                let email = Constants.adminEmail
                let subject = "Feature Suggestion"
                let body = "Please leave a detailed feature suggestion below: \n\n"
                self?.showMailComposer(with: email, and: subject, and: body)
            })
        ],
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

// MARK: - TableView
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

// MARK: - Mail
extension SettingsController: MFMailComposeViewControllerDelegate {

    private func showMailComposer(with email: String, and subject: String, and body: String) {
        guard MFMailComposeViewController.canSendMail() else {
            AlertManager.showEmailErrorAlert(on: self)
            return
        }

        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([email])
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)

        present(composer, animated: true)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            AlertManager.showEmailErrorAlert(on: self)
            controller.dismiss(animated: true, completion: nil)
            return
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ShareSheet
extension SettingsController {
    
    private func presentShareSheet() {
        guard let url = URL(string: Constants.appStore) else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = self.view
        shareSheetVC.popoverPresentationController?.sourceRect = self.view.frame
        present(shareSheetVC, animated: true)
    }
}
