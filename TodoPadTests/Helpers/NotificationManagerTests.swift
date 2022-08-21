//
//  NotificationManagerTests.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-20.
//

import XCTest
@testable import TodoPad

class NotificationManagerTests: XCTestCase {
    
    override func tearDownWithError() throws {
        NotificationManager.removeAllNotifications()
    }
    
    // MARK: - Create Repeating Task
    func testSetNotification_DailyRepeatingTask_CreatesNotification() {
        // Arrange
        let rTask = RepeatingTask(title: "My Daily Repeating", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24), time: Date().addingTimeInterval(60*60*2), repeatSettings: .daily, endDate: nil, notificationsEnabled: true)
        
        // Act
        let expectation = self.expectation(description: "Daily Notifications")
        NotificationManager.setNotification(for: Task.repeating(rTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 1)
            
            let request = requests.first
            XCTAssertTrue(request?.content.body.contains(rTask.title) ?? false)
            XCTAssertEqual(request?.identifier, rTask.taskUUID.uuidString)
            XCTAssertTrue(request?.trigger?.repeats ?? false)
            
            if let triggerDateComponents = (request?.trigger as? UNCalendarNotificationTrigger)?.dateComponents, let time = rTask.time {
                
                let rTaskComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                XCTAssertEqual(triggerDateComponents.hour, rTaskComponents.hour)
                XCTAssertEqual(triggerDateComponents.minute, rTaskComponents.minute)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSetNotification_WeeklyRepeatingTask_CreatesNotification() {
        // Arrange
        let rTask = RepeatingTask(title: "My Daily Repeating", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24), time: Date().addingTimeInterval(60*60*2), repeatSettings: .weekly([1, 3, 6]), endDate: nil, notificationsEnabled: true)
        
        // Act
        let expectation = self.expectation(description: "Weekly Notifications")
        NotificationManager.setNotification(for: Task.repeating(rTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 3)
            
            for (index, request) in requests.enumerated() {
                if let triggerDateComponents = (request.trigger as? UNCalendarNotificationTrigger)?.dateComponents{
                
                    if let time = rTask.time {
                        let rTaskComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                        XCTAssertEqual(triggerDateComponents.hour, rTaskComponents.hour)
                        XCTAssertEqual(triggerDateComponents.minute, rTaskComponents.minute)
                    }
                    
                    XCTAssertEqual(triggerDateComponents.weekday, rTask.repeatSettings.getWeeklyArray?[index])
                    
                    let identiferString = rTask.taskUUID.uuidString + "_" + (rTask.repeatSettings.getWeeklyArray?[index].description ?? "")
                    XCTAssertEqual(request.identifier, identiferString)
                    XCTAssertTrue(request.content.body.contains(rTask.title))
                } else {
                    XCTFail()
                }
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    func testSetNotification_MonthlyRepeatingTask_CreatesNotification() {
        // Arrange
        let rTask = RepeatingTask(title: "My Daily Repeating", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24), time: Date().addingTimeInterval(60*60*2), repeatSettings: .monthly, endDate: nil, notificationsEnabled: true)
        
        // Act
        let expectation = self.expectation(description: "Monthly Notifications")
        NotificationManager.setNotification(for: Task.repeating(rTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 1)
            
            let request = requests.first
            XCTAssertTrue(request?.content.body.contains(rTask.title) ?? false)
            XCTAssertEqual(request?.identifier, rTask.taskUUID.uuidString)
            XCTAssertTrue(request?.trigger?.repeats ?? false)
            
            if let triggerDateComponents = (request?.trigger as? UNCalendarNotificationTrigger)?.dateComponents{
                
                let rTaskDayComponent = Calendar.current.dateComponents([.day], from: rTask.startDate).day
                XCTAssertEqual(triggerDateComponents.day, rTaskDayComponent)
                
                if let time = rTask.time {
                    let rTaskComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                    XCTAssertEqual(triggerDateComponents.hour, rTaskComponents.hour)
                    XCTAssertEqual(triggerDateComponents.minute, rTaskComponents.minute)
                }
                
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    func testSetNotification_YearlyRepeatingTask_CreatesNotification() {
        // Arrange
        let rTask = RepeatingTask(title: "My Daily Repeating", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24), time: Date().addingTimeInterval(60*60*2), repeatSettings: .yearly, endDate: nil, notificationsEnabled: true)
        
        // Act
        let expectation = self.expectation(description: "Yearly Notifications")
        NotificationManager.setNotification(for: Task.repeating(rTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 1)
            
            let request = requests.first
            XCTAssertTrue(request?.content.body.contains(rTask.title) ?? false)
            XCTAssertEqual(request?.identifier, rTask.taskUUID.uuidString)
            XCTAssertTrue(request?.trigger?.repeats ?? false)
            
            if let triggerDateComponents = (request?.trigger as? UNCalendarNotificationTrigger)?.dateComponents{
                
                let rTaskDayComponent = Calendar.current.dateComponents([.day], from: rTask.startDate).day
                XCTAssertEqual(triggerDateComponents.day, rTaskDayComponent)
                
                let rTaskMonthComponent = Calendar.current.dateComponents([.month], from: rTask.startDate).month
                XCTAssertEqual(triggerDateComponents.month, rTaskMonthComponent)
                
                if let time = rTask.time {
                    let rTaskComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                    XCTAssertEqual(triggerDateComponents.hour, rTaskComponents.hour)
                    XCTAssertEqual(triggerDateComponents.minute, rTaskComponents.minute)
                }
                
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    // MARK: - Create Non-Repeating Task
    func testSetNotification_NonRepeatingTask_CreatesNotification() {
        // Arrange
        let nonRepTask = NonRepeatingTask(title: "My Nonrep Task", desc: nil, taskUUID: UUID(), isCompleted: false, date: Date().addingTimeInterval(60*60*24*91), time: Date().addingTimeInterval(60*60*3), notificationsEnabled: false)
        
        // Act
        let expectation = self.expectation(description: "Non Repeating Notifications")
        NotificationManager.setNotification(for: Task.nonRepeating(nonRepTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 1)
            
            let request = requests.first
            XCTAssertTrue(request?.content.body.contains(nonRepTask.title) ?? false)
            XCTAssertEqual(request?.identifier, nonRepTask.taskUUID.uuidString)
            XCTAssertFalse(request?.trigger?.repeats ?? true)
            
            if let triggerDateComponents = (request?.trigger as? UNCalendarNotificationTrigger)?.dateComponents{
                
                let rTaskDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nonRepTask.date)
                XCTAssertEqual(triggerDateComponents.day, rTaskDateComponents.day)
                XCTAssertEqual(triggerDateComponents.month, rTaskDateComponents.month)
                XCTAssertEqual(triggerDateComponents.year, rTaskDateComponents.year)
                
                if let time = nonRepTask.time {
                    let rTaskComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                    XCTAssertEqual(triggerDateComponents.hour, rTaskComponents.hour)
                    XCTAssertEqual(triggerDateComponents.minute, rTaskComponents.minute)
                }
                
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3)
    }
    
    // MARK: - Delete Notification
    func testDeleteNotificationForTask_WeekyTask_DeletesNotification() {
        // Arrange
        let rTask = RepeatingTask(title: "My Daily Repeating", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24), time: Date().addingTimeInterval(60*60*2), repeatSettings: .weekly([1, 3, 6]), endDate: nil, notificationsEnabled: true)
        
        // Act
        let expectation = self.expectation(description: "Delete Weekly Notifications")
        NotificationManager.setNotification(for: Task.repeating(rTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 3)
            
            NotificationManager.removeNotifications(for: Task.repeating(rTask))
            
            NotificationManager.getAllPendingNotifications { requests in
                XCTAssertEqual(requests.count, 0)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3)
    }
    
    func testDeleteNotificationForTask_NonWeeklyTask_DeletesNotification() {
        // Arrange
        let rTask = RepeatingTask(title: "My Daily Repeating", desc: nil, taskUUID: UUID(), isCompleted: false, startDate: Date().addingTimeInterval(60*60*24), time: Date().addingTimeInterval(60*60*2), repeatSettings: .daily, endDate: nil, notificationsEnabled: true)
        
        // Act
        let expectation = self.expectation(description: "Daily Notifications")
        NotificationManager.setNotification(for: Task.repeating(rTask))
        sleep(1)
        
        // Assert
        NotificationManager.getAllPendingNotifications { requests in
            XCTAssertEqual(requests.count, 1)
            
            NotificationManager.removeNotifications(for: Task.repeating(rTask))
            
            NotificationManager.getAllPendingNotifications { requests in
                XCTAssertEqual(requests.count, 0)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3)
    }
    
}
