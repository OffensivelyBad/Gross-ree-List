//
//  BaseViewController.swift
//  Gross-ree List
//
//  Created by Shawn Roller on 3/8/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
