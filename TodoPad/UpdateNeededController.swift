//
//  UpdateNeededController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-28.
//

import UIKit

class UpdateNeededController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .dynamicColorOne
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Update Required", message: "An update is required to continue using this app.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Appstore", style: .default, handler: { _ in
            guard let appStorePage = URL(string: Constants.appStore) else { return }
            UIApplication.shared.open(appStorePage, options: [:], completionHandler: nil)
        }))
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
