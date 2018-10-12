//
//  ECCompleteProfileViewController.swift
//  FabricSell
//
//  Created by KiwiTech on 19/09/18.
//

import UIKit

class ECCompleteProfileViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var desctionTextField: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    // MARK: - private property
    fileprivate var firstScrollViewPostion: CGFloat = 0
    fileprivate var activeField: UITextField?
    fileprivate var lastOffset: CGPoint!
    fileprivate var keyboardHeight: CGFloat!
    // MARK: - Guest user/New
    internal var isOtherUser = EngagingChoiceUserType.new
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        mobileNumberTextField.delegate = self
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Set numberOfLines
        desctionTextField.numberOfLines = 0;
        // call `sizeToFit` to make text top left
        desctionTextField.sizeToFit()
        let attributedString = NSMutableAttributedString(string: isOtherUser == EngagingChoiceUserType.new ? EngagingChoiceName.newUserProfileSubTitle.rawValue : EngagingChoiceName.guestUserProfileSubTitle.rawValue)
        // Create instance of NSMutableParagraphStyle
        let paragraphStyle = NSMutableParagraphStyle()
        // set LineSpacing property in points
        paragraphStyle.lineSpacing = 8
        // Apply attribute to string
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // Set Attributed String to your label
        desctionTextField.attributedText = attributedString
    }
    // MARK: - Proceed for Register
    @IBAction func proceed(_ sender: UIButton) {
        activeField?.resignFirstResponder()
        guard let email = self.emailTextField.text else {
            showAlertView(with: EngagingChoiceName.alertMessage.rawValue)
            return
        }
        guard let mobileNumber = self.mobileNumberTextField.text else {
            showAlertView(with: EngagingChoiceName.alertMessage.rawValue)
            return
        }
        if !email.isEmpty && !mobileNumber.isEmpty {
            // Call API for Registration
            sender.isEnabled = false
            ECDownloadManager.shared.updateUserInfo(email: email, number: mobileNumber, success: {
                    self.showAlertView(with: EngagingChoiceName.success.rawValue, isSuccessMessage: true)
            }) { (error) in
                sender.isEnabled = true
                self.showAlertView(with: error)
            }
        } else {
            showAlertView(with: EngagingChoiceName.alertMessage.rawValue)
        }
    }
    func showAlertView(with message: String, isSuccessMessage: Bool = false)  {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if isSuccessMessage {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Close View Action
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: TextField Delegate
extension ECCompleteProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.firstScrollViewPostion = self.scrollView.contentOffset.y
        activeField = textField
        lastOffset = self.scrollView.contentOffset
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            mobileNumberTextField.becomeFirstResponder()
        } else {
            mobileNumberTextField.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
        return false
    }
}
// MARK: Keyboard Handling
extension ECCompleteProfileViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil || activeField == nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            if activeField == self.emailTextField {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: keyboardHeight), animated: true)
            } else {
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: keyboardHeight), animated: true)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.setContentOffset(CGPoint(x: lastOffset.x, y: lastOffset.y), animated: true)
        keyboardHeight = nil
    }
}

