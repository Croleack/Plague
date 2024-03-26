//
//  AlertManager.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import UIKit

final class AlertManager {
    static func showAlert(in viewController: UIViewController, title: String, message: String) {
	   let alert = UIAlertController(
		  title: title,
		  message: message,
		  preferredStyle: .alert
	   )
	   alert.addAction(UIAlertAction(title: "OK", style: .default))
	   viewController.present(alert, animated: true)
    }
}
