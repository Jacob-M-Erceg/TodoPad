//
//  TabBarController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class TabBarController: UITabBarController, TasksControllerDelegate {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .dynamicColorTwo
        self.setupViewControllers()
        
        self.selectedIndex = 1 // TODO - delete
    }
    
    // MARK: - Helpers
    private func setupViewControllers() {
        let tasksController = TasksController()
                tasksController.delegate = self
        let tasks = self.templateNavigationController(image: UIImage(systemName: "list.bullet"), title: "Tasks", rootViewController: tasksController)
        
        let stats = self.templateNavigationController(image: UIImage(systemName: "chart.bar.fill"), title: "Stats", rootViewController: StatsController())
        
        self.setViewControllers([tasks, stats], animated: false)
    }
    
    private func templateNavigationController(image: UIImage?, title: String, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        nav.viewControllers[0].title = title
        nav.setupNavBarColor()
        return nav
    }
    
    // MARK: - Show Task Completed Popup
    var taskCountAnimationArray: [Int] = []
    var animationInProg = false
    
    // Delegate Callback Function
    func showTaskCompletedPopup() {
        //        let vm = StatsControllerViewModel()
        //        vm.fetchData()
        //        let taskCount = vm.fetchTotalTasksCompletedCount()
        //        // Add taskCount to queue
        //        self.taskCountAnimationArray.append(taskCount)
        //
        //        // Block if animating... it will call itself if taskCount in queue
        //        if animationInProg != true {
        //            self.doAnimation()
        //        }
    }
    
    //    private func doAnimation()  {
    //        guard taskCountAnimationArray.count > 0 else { return }
    //        // Set true to block from animating twice at a time
    //        animationInProg = true
    //
    //        let tCompView = TaskCompletedPopup()
    //        tCompView.configure(tasksCompleted: taskCountAnimationArray.first!)
    //
    //        self.view.addSubview(tCompView)
    //        tCompView.frame = CGRect(x: self.view.width/10, y: self.view.height, width: self.view.width*0.8, height: 68)
    //
    //        DispatchQueue.main.async { [weak self] in
    //            UIView.animate(withDuration: 1) {
    //                tCompView.transform = CGAffineTransform(translationX: 0, y: -190)
    //            } completion: { [weak self] done in
    //                if done {
    //                    DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
    //                        UIView.animate(withDuration: 1) {
    //                            tCompView.transform = .identity
    //                        } completion: { done in
    //                            if done {
    //                                tCompView.removeFromSuperview()
    //                                // Remove current taskCount from queue and stop blocking animation
    //                                self?.taskCountAnimationArray.removeFirst()
    //                                self?.animationInProg = false
    //
    //                                // If queue still has taskCounts queued, do animation
    //                                if let _ = self?.taskCountAnimationArray.first {
    //                                    self?.doAnimation()
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
}
