//
//  AlertManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-20.
//

import UIKit

// MARK: - Basic Alerts
class AlertManager {
    
    
    /// A helper funtion to show a basic alert with a title, an optional message and a "Dismiss" button.
    /// - Parameters:
    ///   - vc: The UIViewController that you wish to display the alert on.
    ///   - title: The title for the alert.
    ///   - message: A optional additional message for the alert.
    static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    
    /// Shows an error saying you cant currently edit a task's type. Example: you cannot currently change a Repeating Task to a Persistent Task.
    static func showCannotEditTaskTypeErrorAlert(on vc: UIViewController, firstTaskType: String, secondTaskType: String) {
        self.showBasicAlert(on: vc, title: "Editing Error", message: "You cannot currently change a \(firstTaskType) Task to a \(secondTaskType) Task.")
    }
    
    static func showNotificationsPermissionsError(on vc: UIViewController, _ errorMessage: String) {
        self.showBasicAlert(on: vc, title: "Notification Permissions Error", message: "Please enable notifications for this app in your phones settings. ERROR: \(errorMessage)")
    }
    
    static func showMaximumNotificationsError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Maximum Notifications", message: "You can only set 64 notifications currently. For weekly tasks, each weekday counts as its own seperate notification. Please turn off notifications for some of your current events to enable this notification.")
    }
    
    static func showSetNotificationError(on vc: UIViewController, taskTitle: String, error: Error?) {
        self.showBasicAlert(on: vc, title: "Could not create notification for \(taskTitle)", message: error?.localizedDescription)
    }
}

// MARK: - Destructive Alerts
extension AlertManager {
    
    /// A helper function that shows a destructive "Continue" or "Cancel" alert.
    /// - Parameters:
    ///   - vc: The UIViewController that you wish to display the alert on.
    ///   - title: The title for the alert.
    ///   - message: A optional additional message for the alert.
    ///   - completion: Boolean True means to continue with the desctrutive action. Boolean False means to cancel the destructive action.
    private static func showDestructiveAlert(on vc: UIViewController, title: String, message: String?, completion: @escaping (Bool)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { _ in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion(false)
        }))
        
        DispatchQueue.main.async { vc.present(alert, animated: true, completion: nil) }
    }
    
    public static func showDeleteAllNotificationskWarning(on vc: UIViewController, completion: @escaping (Bool)->()) {
        self.showDestructiveAlert(
            on: vc,
            title: "Are you sure you want to delete all notifications?",
            message: "This will completely delete all notifications for all your tasks. You will have to edit your tasks and re-enable them.",
            completion: completion
        )
    }
    
    public static func showDeleteAllTaskskWarning(on vc: UIViewController, completion: @escaping (Bool)->()) {
        self.showDestructiveAlert(
            on: vc,
            title: "Are you sure you want to delete all tasks?",
            message: "This will delete all completed and non completed tasks. It will completely wipe all stats history. You will not be able to recover once deleted.",
            completion: completion
        )
    }
    
}
