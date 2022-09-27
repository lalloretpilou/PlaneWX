//
//  HapticVibration.swift
//  PlaneCalc
//
//  Created by Pierre-Louis L'ALLORET on 19/10/2021.
//

import Foundation
import UIKit

func hapticSucess() {
    let generator = UINotificationFeedbackGenerator()
        
    if UIAccessibility.isShakeToUndoEnabled {
        generator.notificationOccurred(.success)
    }
}

func hapticError() {
    let generator = UINotificationFeedbackGenerator()
    if UIAccessibility.isShakeToUndoEnabled {
    generator.notificationOccurred(.error)
    }
}

func hapticWarning() {
    let generator = UINotificationFeedbackGenerator()
    if UIAccessibility.isShakeToUndoEnabled {
    generator.notificationOccurred(.warning)
    }
}

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
