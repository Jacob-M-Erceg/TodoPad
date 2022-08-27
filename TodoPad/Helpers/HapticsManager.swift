//
//  HapticsManager.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-26.
//

import UIKit

/// Object that deals with haptic feedback
final class HapticsManager {
    /// Shared singleton instance
    static let shared = HapticsManager()

    /// Private constructor
    private init() {}
    
    /// Vibrate for light selection of item
    public func vibrateForLightSelection() {
        let genorator = UIImpactFeedbackGenerator()
        genorator.prepare()
        genorator.impactOccurred(intensity: 0.50)
    }

    /// Vibrate for selection of item
    public func vibrateForSelection() {
        let genorator = UIImpactFeedbackGenerator()
        genorator.prepare()
        genorator.impactOccurred(intensity: 0.75)
    }
    
    /// Vibrate for action completed
    public func vibrateForActionCompleted() {
        let genorator = UIImpactFeedbackGenerator()
        genorator.prepare()
        genorator.impactOccurred(intensity: 1)
    }

    /// Trigger feedback vibration based on event type
    /// - Parameter type: Success, Error, or Warning type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
