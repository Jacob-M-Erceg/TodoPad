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
        
        var cdLocation = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/../Library/Application\\")
        cdLocation?.removeLast()
        cdLocation = cdLocation?.appending(" Support/")
        devPrint(cdLocation ?? "")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // TODO - 
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

