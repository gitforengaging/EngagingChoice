//
//  UtilitiesExtensions.swift
//  EngagingChoice
//
//  Created by KiwiTech on 10/09/18.
//

import UIKit

enum EngagingChoiceName:String {
    case poweredBy = "Powered by"
    case validTill = "Valid Till"
    case newUserProfileSubTitle = "Your Profile is not complete yet, Please complete your profile first and get more offers."
    case guestUserProfileSubTitle = "Your Profile is not complete yet, Please complete your profile first using new email id and get more offers."
    case alertMessage = "Please fill all required fields"
    case success =  "Your details have been saved successfully"
    case locationAlertHeading = "Location Services Disabled"
    case locationAlertMessage = "Please enable Location Services in Settings"
}
enum EngagingChoiceGridCell:CGFloat {
    case cellHeight = 200
    case numberOfCell = 3
}
enum EngagingChoiceAPIBaseURL:String {
    case qa = "https://engagingchoice-qa.kiwireader.com/publisherapi"
    case dev = "https://engagingchoice-dev.kiwireader.com/publisherapi"
    case staging = "https://engagingchoice-staging.kiwireader.com/publisherapi"
    case loadTesting = "https://engagingchoice-loadtesting.kiwireader.com/publisherapi"
    static var baseURL: String {
        return EngagingChoiceAPIBaseURL.qa.rawValue
    }
}
enum EngagingChoiceAPIEndPoint:String {
    case offerList = "/offer-list"
    case contentList = "/content-list"
    case contentDetail = "/content-details"
    case viewCount = "/view-count"
    case updatUserInfo = "/user-update-info"
    case offerAction = "/offer-action"
    var url: String {
        switch self {
        case .offerList:
            return "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.offerList.rawValue)"
        case .contentList:
            return "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.contentList.rawValue)"
        case .contentDetail:
            return "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.contentDetail.rawValue)"
        case .viewCount:
            return "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.viewCount.rawValue)"
        case .offerAction:
            return "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.offerAction.rawValue)"
        case .updatUserInfo:
            return "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.updatUserInfo.rawValue)"
        }
    }
}
enum FormatterDate:String {
    case MMDY = "MMM dd, yyyy"
    case defaultDateFormatter = "yyyy-dd-mm"
}
enum EngaingChoiceAPIKey:String {
    case id = "id"
    case mobile = "mobile_no"
    case email = "email"
    case oldEmail = "old_email"
    case type = "type"
    case offerId = "offer_id"
    case contentId = "content_id"
    case action = "action"
}
enum EngagingChoiceTypeValue: Int {
    case offer = 1, content
}
// MARK: - Later Action
enum EngagingChoiceOfferAction: Int {
    case getOffer = 1, later, skip
}
// MARK: - Status Code
enum EngagingChoiceAPIStatusCode: Int {
    case ok = 200
    case badRequest = 400
}
// MARK: - Parameters Keys
enum EngagingChoiceAPIKey: String {
    case offset = "page"
    case limit = "per_page"
}
// MARK: - File Type - Image/Video
enum EngagingChoiceFileType: Int {
    case none = 0, image = 1, video = 2
}
// MARK: - Type Guest User/New
enum EngagingChoiceUserType: Int {
    case new = 0, guest
}
// MARK: - Show Popup
enum EngagingChoiceShowPopup: Int {
    case hide = 0, show
}
// MARK: - Discount Type
enum EngagingChoiceDiscountType: Int {
    case buyOneGetOne = 1, currency, percentage
}
extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            debugPrint("Couldn't find font \(fontName)")
            return false
        }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            debugPrint("Couldn't load data from the font \(fontName)")
            return false
        }
        guard let font = CGFont(fontDataProvider) else {
            debugPrint("Couldn't create font from data")
            return false
        }
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            return false
        }
        return true
    }
}
extension UIFont {
    static func loadFonts() {
        _ = UIFont.registerFont(bundle: Bundle.bundle, fontName: "OpenSans-SemiBold", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: Bundle.bundle, fontName: "OpenSans-Bold", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: Bundle.bundle, fontName: "OpenSans-Regular", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: Bundle.bundle, fontName: "OpenSans-LightItalic", fontExtension: "ttf")
    }
}
extension UIImage {
    static var poweredByIcon:UIImage? {
        return UIImage(named: "icon", in: Bundle.bundle, compatibleWith: nil)
    }
    static var poweredByWithText:UIImage? {
        return UIImage(named: "logoWithEngagingChoice", in: Bundle.bundle, compatibleWith: nil)
    }
    static var pauseImage:UIImage? {
        return UIImage(named: "pause-icon", in: Bundle.bundle, compatibleWith: nil)
    }
    static var playImage:UIImage? {
        return UIImage(named: "play-icon", in: Bundle.bundle, compatibleWith: nil)
    }
    static var cellShimmer:UIImage? {
        return UIImage(named: "cellShimmer", in: Bundle.bundle, compatibleWith: nil)
    }
}
extension UIColor {
    static var poweredByColor:UIColor {
        return UIColor(red: 52/255, green: 62/255, blue: 74/255, alpha: 1.0)
    }
}
extension Bundle {
    static var bundle:Bundle {
        let podBundle = Bundle(for: ECOfferTableViewCell.self)
        guard let bundle = podBundle.url(forResource: "EngagingChoice", withExtension: "bundle"), let bundleURL = Bundle(url: bundle) else {
            fatalError("Expected `\(ECOfferTableViewCell.self)` Bundle not found in EngagingChoice.")
        }
        return bundleURL
    }
}
// MARK: - Video View Utilities class
class VideoContainerView: UIView {
    var playerLayer: CALayer?
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
}
