//
//  MockTasksController.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-16.
//

import UIKit
@testable import TodoPad

class MockTasksController: TasksController {
    
    var spyPresentedViewController: UIViewController!
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        self.spyPresentedViewController = viewControllerToPresent
    }
}
