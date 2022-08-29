//
//  AppReviewRequest.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-27.
//

import UIKit
import StoreKit

enum AppReviewRequest {
    
    static func requestReviewIfNeeded(on vc: UIViewController) {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
                UserDefaultsManager.setRatedAppAlreadyTrue()
            } else {
                self.manuallyRequestReviewIfNeeded(on: vc)
            }
        }
    }
    
    static func manuallyRequestReviewIfNeeded(on vc: UIViewController) {
        guard let writeReviewURL = URL(string: Constants.appStoreReview) else {
            AlertManager.showCannotRateAppAlert(on: vc)
            return
        }
        UserDefaultsManager.setRatedAppAlreadyTrue()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
}
