//
//  ECGridManager.swift
//  FabricSell
//
//  Created by KiwiTech on 04/09/18.
//

import UIKit
import AVKit

protocol OfferGridCompletionDelegate:NSObjectProtocol {
    func didFinishedShowOffer()
}
public class ECGridManager: NSObject, OfferGridCompletionDelegate {
    // MARK: - Class shared instance
    public static let shared = ECGridManager()
    // MARK: - Private var
    fileprivate static var secretKey:String?
    // MARK: - fileprivate var
    fileprivate static var email:String?
     // MARK: - Make init private
    private override init() {}
    // private clouse
    var showGridCallback:(() -> Void) = {}
     // MARK: - Get secret key
    internal var getSecretKey:String? {
        if (ECGridManager.secretKey == nil) {
            print("Secret key is not available, Please set Secret key in ECGrimanager.config(secretKey key:String) and add this line of code in didFinishLaunchingWithOptions.")
        }
        return ECGridManager.secretKey
    }
    internal var getEmailAddress:String? {
        if (ECGridManager.email == nil) {
            print("Email is mandatory, Please set login user email address in showOfferList(view controller:UIViewController, email:String).")
        }
        return ECGridManager.email
    }
    // MARK: - Config Key
    /**
        Set secret key to request API from server
     */
    ///
    /// - Parameter key: It's mandatory field to make API request
    public func config(secretKey key:String) {
        ECGridManager.secretKey = key
    }
    // MARK: - Show Offer List View Controller
    /**
        Provide viewController to open OfferList View
        Email is mandatory to show Offer List View Cotroller
     */
    ///
    /// - Parameters:
    ///   - controller: View in which Controller present
    ///   - email: Email is used to fetch filter offer list
    public static func showOfferList(view controller:UIViewController, email:String) {
        ECGridManager.email = email.isEmpty ? nil : email
        let gridViewController = ECOfferViewController(nibName: "\(ECOfferViewController.self)", bundle: Bundle.bundle)
        controller.present(gridViewController, animated: true, completion: nil)
    }
    // MARK: - Show Offer List View Controller with completion handler
    public static func showOfferList(view controller:UIViewController, email:String, completion: @escaping (() -> Swift.Void)) {
        ECGridManager.shared.showGridCallback = completion
        ECGridManager.email = email.isEmpty ? nil : email
        let gridViewController = ECOfferViewController(nibName: "\(ECOfferViewController.self)", bundle: Bundle.bundle)
        gridViewController.showGridDelegate = ECGridManager.shared
        controller.present(gridViewController, animated: true, completion: nil)
    }
    // MARK: - Show Grid Completion Delegate
    internal func didFinishedShowOffer() {
        ECGridManager.shared.showGridCallback()
    }
     // MARK: - Show complete registration profile popUp
    internal func showCompeteProfilePopup(view controller: UIViewController, isGuest: EngagingChoiceUserType = .new)  {
       let popUpController = ECCompleteProfileViewController(nibName: "\(ECCompleteProfileViewController.self)", bundle: Bundle.bundle)
        popUpController.providesPresentationContextTransitionStyle = true
        popUpController.definesPresentationContext = true
        popUpController.isOtherUser = isGuest
        popUpController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        popUpController.view.backgroundColor = UIColor(white: 0.4, alpha: 0.9)
        controller.present(popUpController, animated: true, completion: nil)
    }
}
