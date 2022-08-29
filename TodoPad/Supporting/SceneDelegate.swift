//
//  SceneDelegate.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabBarController()
        self.window = window
        self.window?.makeKeyAndVisible()
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+1) { [weak self] in
            self?.checkForRequiredMinimumVersion()
        }
        
        var cdLocation = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/../Library/Application\\")
        cdLocation?.removeLast()
        cdLocation = cdLocation?.appending(" Support/")
        devPrint(cdLocation ?? "")
        
//        UserDefaults.standard.set(nil, forKey: Constants.ratedAppAlreadyKey)
//        UserDefaults.standard.set(nil, forKey: Constants.lastAskedForAppReviewKey)
//        devPrint(UserDefaultsManager.getRatedAppAlreadyValue())
//        devPrint(UserDefaultsManager.getLastAskedForReviewDate())
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        self.saveContext()
    }
    
    private func saveContext() {
        let context = CoreDataStack.shared.context
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func checkForRequiredMinimumVersion() {
        // Get Current App Version
        if var curAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let curAppBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            curAppVersion.append("." + curAppBuild)
            
            // Get Minimum App Version
            AppConfService.getMinimumAppVersion { [weak self] result in
                switch result {
                case .success(let minAppVersion):
                    
                    // If Current App Version Is Less Than Minimum App Version - else do nothing
                    if curAppVersion.compare(minAppVersion, options: .numeric) == .orderedAscending {
                        DispatchQueue.main.async {
                            // Show UpdateNeededController
                            let vc = UpdateNeededController()
                            
                            // If True - Show Alert On Top of Homepage View
                            // Else - Show Alert Over Black Screen
                            if let curView = self?.window?.rootViewController?.view {
                                self?.window?.rootViewController = vc
                                vc.view.addSubview(curView)
                                curView.frame = CGRect(x: 0, y: 0, width: vc.view.width, height: vc.view.height)
                            } else {
                                self?.window?.rootViewController = vc
                            }
                        }
                    }
                case .failure(_): break
                }
            }
        }
    }
    
}

