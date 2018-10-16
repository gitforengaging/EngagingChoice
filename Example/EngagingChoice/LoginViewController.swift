//
//  LoginViewController.swift
//  EngagingChoice
//
//  Created by KiwiTech on 19/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue:220/255, alpha: 1.0).cgColor
        passwordTextField.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue:220/255, alpha: 1.0).cgColor
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        emailTextField.delegate = self
    }
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if textField.text?.isEmpty == false {
                appDelegate.emailAddres = textField.text
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField.resignFirstResponder()
        return true
    }
}
