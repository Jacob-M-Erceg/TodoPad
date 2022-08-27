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
    
    static func showNotificationsNotGrantedError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Please Allow Notifications", message: "Please allow notifications for TodoPad in your settings to enable notifications.")
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
    
    /// A warning against permanently deleting a NonRepeating or Persistent task.
    /// - Parameters:
    ///   - completion: Boolean True to delete task. Boolean False to cancel.
    public static func showDeleteTaskWarning(on vc: UIViewController, completion: @escaping (Bool)->()) {
        self.showDestructiveAlert(
            on: vc,
            title: "Are you sure you want to delete this task?",
            message: nil,
            completion: completion
        )
    }
    
    /// A warning against completely deleting a Repeating task including all past completed days.
    /// - Parameters:
    ///   - completion: Boolean True to delete task. Boolean False to cancel.
    public static func showCompletelyDeleteRepeatingTaskWarning(on vc: UIViewController, completion: @escaping (Bool)->()) {
        self.showDestructiveAlert(
            on: vc,
            title: "Are you sure?",
            message: "All previously completed days will be deleted for this task. You will be unable to recover the task.",
            completion: completion
        )
    }
    
    
    /// A warning against permanently deleting ALL tasks from core data
    /// - Parameters:
    ///   - completion: Boolean True to delete all tasks. Boolean False to cancel.
    public static func showDeleteAllTaskskWarning(on vc: UIViewController, completion: @escaping (Bool)->()) {
        self.showDestructiveAlert(
            on: vc,
            title: "Are you sure you want to delete all tasks?",
            message: "This will delete all completed and non completed tasks. It will completely wipe all stats history. You will not be able to recover once deleted.",
            completion: completion
        )
    }
}


// MARK: - Options Alerts
extension AlertManager {
    
    /// A helper funtion to show an alert with different action buttons.
    /// - Parameters:
    ///   - vc: The UIViewController that you wish to display the alert on.
    ///   - title: The title for the alert.
    ///   - message: A optional additional message for the alert.
    ///   - actions: An array of UIAlertAction's to add to the alert.
    private static func showActionAlert(on vc: UIViewController, title: String, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /// An alert to choose how the user wants to delete a task.
    /// - Parameters:
    ///   - completion: AlertManager.DeleteTaskOption Enum
    static func showDeleteRepeatingTaskAlert(on vc: UIViewController, completion: @escaping (AlertManager.DeleteRepeatingTaskOption)->Void) {
        let actions = [
            UIAlertAction(title: DeleteRepeatingTaskOption.allFuture.rawValue, style: .default, handler: { alertAction in
                completion(DeleteRepeatingTaskOption.allFuture)
            }),
            UIAlertAction(title: DeleteRepeatingTaskOption.allTasks.rawValue, style: .destructive, handler: { alertAction in
                completion(DeleteRepeatingTaskOption.allTasks)
            }),
            UIAlertAction(title: DeleteRepeatingTaskOption.cancel.rawValue, style: .cancel, handler: { alertAction in
                completion(DeleteRepeatingTaskOption.cancel)
            })
        ]
        self.showActionAlert(on: vc, title: "Delete repeating tasks", message: nil, actions: actions)
    }
    
    enum DeleteRepeatingTaskOption: String {
        case allFuture = "This and all future tasks"
        case allTasks = "All tasks"
        case cancel = "Cancel"
    }
    
}
