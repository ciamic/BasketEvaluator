//
//  Utility.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation
import UIKit

/// Utility properties and methods used throughout the application

// MARK: - Properties

// an autoupdating currency formatter (i.e. based on current user preferences)
let currencyFormatter: NumberFormatter = {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.locale = Locale.autoupdatingCurrent
    currencyFormatter.numberStyle = .currency
    return currencyFormatter
}()

// MARK: - NumberFormatter

// Convenience method in order to format a Decimal number with a NumberFormatter bridging to NSDecimalNumber
extension NumberFormatter {
    
    func string(from decimal: Decimal) -> String? {
        return string(from: decimal as NSDecimalNumber)
    }
    
}

// MARK: - UIApplication AppDelegate

extension UIApplication {
    
    var appDelegate: AppDelegate {
        return delegate as! AppDelegate
    }
    
}

// MARK: - UIViewController destination

extension UIViewController {
    
    /// if toViewController is a navigation controller, tries to "skip" it and return it's visible view controller 
    func destination() -> UIViewController {
        var destinationViewController = self
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        
        return destinationViewController
    }
    
}

// MARK: - Notifications

func sendDataNotification(notificationName: String, withObject object: Any?, userInfo: [AnyHashable:Any]?) {
    NotificationCenter.default.post(name: Notification.Name(notificationName), object: object, userInfo: userInfo)
}

// MARK: - Alerts

extension UIViewController {

    func showSimpleAlert(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: AlertMessages.ActionConfirmTitle, style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
}


