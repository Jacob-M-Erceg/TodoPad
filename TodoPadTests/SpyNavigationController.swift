//
//  SpyNavigationController.swift
//  TodoPadTests
//
//  Created by John Lee on 2022-08-04.
//

import UIKit

class SpyNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController!
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        pushedViewController = viewController
    }
}
