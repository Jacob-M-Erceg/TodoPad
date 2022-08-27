//
//  NotificationManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-20.
//

import UIKit
import UserNotifications

// MARK: - Create Notifications
class NotificationManager {
    
    static func setNotification(for task: Task) {
        switch task {
        case .persistent(_):
            break
            
        case .repeating(let repeatingTask):
            self.setNotification(for: repeatingTask)
            
        case .nonRepeating(let nonRepeatingTask):
            self.setNotification(for: nonRepeatingTask)
        }
    }
    
    // MARK: - Repeating
    private static func setNotification(for repeatingTask: RepeatingTask) {
        let center = self.getPermissionsAndReturnCenter()
        let content = self.getContent(with: Task.repeating(repeatingTask))
        
        var requests: [UNNotificationRequest] = []
        
        switch repeatingTask.repeatSettings {
        case .daily:
            let req = self.createRequestForDaily(content, repeatingTask)
            requests.append(req)
            
        case .weekly(let weekdays):
            for weekday in weekdays {
                let req = self.createRequestsForWeekly(content, repeatingTask, weekday)
                requests.append(req)
            }
            
        case .monthly:
            let request = self.createRequestsForMonthly(content, repeatingTask)
            requests.append(request)
            
        case .yearly:
            let request = self.createRequestsForYearly(content, repeatingTask)
            requests.append(request)
        }
        
        self.addNotificationRequest(with: center, and: requests, task: Task.repeating(repeatingTask))
    }
    
    // MARK: - Daily
    private static func createRequestForDaily(_ content: UNMutableNotificationContent, _ repeatingTask: RepeatingTask) -> UNNotificationRequest {
        
        var notifComponents = DateComponents()
        notifComponents.timeZone = .current
        
        if let time = repeatingTask.time {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            notifComponents.hour = timeComponents.hour
            notifComponents.minute = timeComponents.minute
        } else {
            notifComponents.hour = 00
            notifComponents.minute = 00
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifComponents, repeats: true)
        let request = UNNotificationRequest(identifier: repeatingTask.taskUUID.uuidString, content: content, trigger: trigger)
        
        return request
    }
    
    // MARK: - Weekly
    private static func createRequestsForWeekly(_ content: UNMutableNotificationContent, _ repeatingTask: RepeatingTask, _ weekday: Int) -> UNNotificationRequest  {
        
        var notifComponents = DateComponents()
        notifComponents.timeZone = .current
        
        if let time = repeatingTask.time {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            notifComponents.hour = timeComponents.hour
            notifComponents.minute = timeComponents.minute
        } else {
            notifComponents.hour = 00
            notifComponents.minute = 00
        }
        
        notifComponents.weekday = weekday
        
        let identifier = repeatingTask.taskUUID.uuidString + "_" + weekday.description
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        return request
    }
    
    // MARK: - Monthly
    private static func createRequestsForMonthly(_ content: UNMutableNotificationContent, _ repeatingTask: RepeatingTask) -> UNNotificationRequest  {
        
        var notifComponents = DateComponents()
        notifComponents.timeZone = .current
        
        let day = Calendar.current.dateComponents([.day], from: repeatingTask.startDate).day
        notifComponents.day = day
        
        if let time = repeatingTask.time {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            notifComponents.hour = timeComponents.hour
            notifComponents.minute = timeComponents.minute
        } else {
            notifComponents.hour = 00
            notifComponents.minute = 00
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifComponents, repeats: true)
        let request = UNNotificationRequest(identifier: repeatingTask.taskUUID.uuidString, content: content, trigger: trigger)
        return request
    }
    
    
    // MARK: - Yearly
    private static func createRequestsForYearly(_ content: UNMutableNotificationContent, _ repeatingTask: RepeatingTask) -> UNNotificationRequest  {
        
        var notifComponents = DateComponents()
        notifComponents.timeZone = .current
        
        let dateComponents = Calendar.current.dateComponents([.month, .day], from: repeatingTask.startDate)
        notifComponents.month = dateComponents.month
        notifComponents.day = dateComponents.day
        
        if let time = repeatingTask.time {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            notifComponents.hour = timeComponents.hour
            notifComponents.minute = timeComponents.minute
        } else {
            notifComponents.hour = 00
            notifComponents.minute = 00
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifComponents, repeats: true)
        let request = UNNotificationRequest(identifier: repeatingTask.taskUUID.uuidString, content: content, trigger: trigger)
        return request
    }
    
    // MARK: - Non-Repeating
    private static func setNotification(for nonRepeatingTask: NonRepeatingTask) {
        let center = self.getPermissionsAndReturnCenter()
        let content = self.getContent(with: Task.nonRepeating(nonRepeatingTask))
        
        var notifComponents = DateComponents()
        notifComponents.timeZone = .current
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nonRepeatingTask.date)
        notifComponents.year = dateComponents.year
        notifComponents.month = dateComponents.month
        notifComponents.day = dateComponents.day
        
        if let time = nonRepeatingTask.time {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
            notifComponents.hour = timeComponents.hour
            notifComponents.minute = timeComponents.minute
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notifComponents, repeats: false)
        let request = UNNotificationRequest(identifier: nonRepeatingTask.taskUUID.uuidString, content: content, trigger: trigger)
        
        self.addNotificationRequest(with: center, and: [request], task: Task.nonRepeating(nonRepeatingTask))
    }
}


// MARK: - Read
extension NotificationManager {
    
    static func getAllPendingNotifications(completion: @escaping ([UNNotificationRequest])->Void) {
        let center = self.getPermissionsAndReturnCenter()
        
        center.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
    static func removeNotifications(for task: Task) {
        let center = self.getPermissionsAndReturnCenter()
        var identifers: [String] = []
        
        identifers.append(task.taskUUID.description)
        
        // For RepeatingTasks
        for x in 1...7 {
            identifers.append(task.taskUUID.description + "_" + x.description)
        }
        
        center.removePendingNotificationRequests(withIdentifiers: identifers)
    }
}


// MARK: - Delete
extension NotificationManager {
    
    static func removeAllNotifications() {
        let center = self.getPermissionsAndReturnCenter()
        center.removeAllPendingNotificationRequests()
    }
}


// MARK: - Helper Functions
extension NotificationManager {
    
    private static func getPermissionsAndReturnCenter() -> UNUserNotificationCenter {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if error != nil {
                DispatchQueue.main.async {
                    if let rootTabBarController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
                        AlertManager.showNotificationsPermissionsError(on: rootTabBarController, error?.localizedDescription ?? "Unknown")
                    }
                }
            }
            
            if granted == false {
                DispatchQueue.main.async {
                    if let rootTabBarController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
                        AlertManager.showNotificationsNotGrantedError(on: rootTabBarController)
                    }
                }
            }
        }
        return center
    }
    
    private static func getContent(with task: Task) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "TodoPad"
        content.body = "Reminder: \(task.title)"
        content.sound = .default
        return content
    }
    
    private static func addNotificationRequest(with center: UNUserNotificationCenter, and requests: [UNNotificationRequest], task: Task) {
        center.getPendingNotificationRequests { reqs in
            guard reqs.count < 64 else {
                DispatchQueue.main.async {
                    if let rootTabBarController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
                        AlertManager.showMaximumNotificationsError(on: rootTabBarController)
                    }
                }
                return
            }
            
            for request in requests {
                center.add(request) { error in
                    guard let error = error else { return }
                    DispatchQueue.main.async {
                        if let rootTabBarController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController {
                            
                            AlertManager.showSetNotificationError(
                                on: rootTabBarController,
                                taskTitle: task.title,
                                error: error
                            )
                        }
                    }
                }
            }
        }
    }
}
