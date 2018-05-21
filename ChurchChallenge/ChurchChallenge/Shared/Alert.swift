//
//  Alert.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/2/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import UIKit

/// Present an alert from any view.
///
/// - Parameters:
///   - title: Title to display on the alert.
///   - message: Message to display on the alert.
public func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    
    var rootViewController = UIApplication.shared.keyWindow?.rootViewController
    if let navigationController = rootViewController as? UINavigationController {
        rootViewController = navigationController.viewControllers.first
    }
    rootViewController?.present(alertController, animated: true, completion: nil)
}
