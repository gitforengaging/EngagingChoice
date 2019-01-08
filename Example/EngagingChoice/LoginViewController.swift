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
    @IBAction func login(_ sender: UIButton) {
        if emailTextField.text?.isEmpty == true {
            showValidationAlert(message: "Please enter email address to continue.", title: "Email Empty")
            return
        } else if isValidEmail(testStr:  emailTextField.text ?? "") == false {
            showValidationAlert(message: "Please enter valid email.", title: "Invalid Email")
            return
        }
        
        self.performSegue(withIdentifier: "showContent", sender: self)
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
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func showValidationAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
