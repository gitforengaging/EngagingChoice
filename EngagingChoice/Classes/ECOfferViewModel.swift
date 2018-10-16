//
//  ECOfferViewModel.swift
//  EngagingChoice
//
//  Created by KiwiTech on 05/09/18.
//

import UIKit
import Alamofire
import CoreLocation
class ECOfferViewModel {
    var offerList = [Offers]()
    var pagination: Pagination?
    var offerModel:Offers!
    var userCoordinates:CLLocationCoordinate2D?
    // MARK: - Computed property
    fileprivate var fileType: EngagingChoiceFileType {
        if let type = EngagingChoiceFileType(rawValue: offerModel.fileType) {
            return type
        }
        return .none
    }
    // MARK: - Fetch Offer List
    internal func fetchOfferList(success:@escaping () -> Void, failed:@escaping (_ error: Error?) -> Void)  {
        // Make sure email address setup correctly
        guard let email = ECGridManager.shared.getEmailAddress else { return }
        // String url address for offerlist with email, longitude and latitude parameter
        var stringURL = "\(EngagingChoiceAPIEndPoint.offerList.url)/\(email)"
        if let coordinates = userCoordinates {
            stringURL.append("/\(coordinates.latitude)/\(coordinates.longitude)")
        }
        // Make sure URL is nil before making request to server
        guard let url = URL(string: stringURL) else { return }
        // Download data from server
        ECDownloadManager.shared.downloadData(with: url, params: nil ,modelType: ECOfferModel.self, success: { (dataModel) in
            if let list = dataModel?.data {
                self.offerList = list
                self.pagination = dataModel?.pagination
                success()
            }
        }) { (error) in
            failed(error)
        }
    }
    // MARK: - Update action
    func updateOfferAction(action: EngagingChoiceOfferAction) {
        ECDownloadManager.shared.updateOfferActionOnServer(action: action, offerId: offerModel.id, contentId: ECMediaContentManager.shared.contentId)
    }
    // MARK: - Create fileURL
    /// Create Image/Video url
    ///
    /// - Parameters:
    ///   - whenImage: This will call for Image file
    ///   - whenVideo: This will call for Video File
    ///   - onfailed: it's optional and it will call on failed
    func createFileURL(whenImage:@escaping (_ url: URL) -> Swift.Void, whenVideo:@escaping (_ url: URL) -> Swift.Void, onfailed:(() -> Swift.Void)? = nil) {
        if let baseURL = self.pagination?.fileURL, let fileURL = offerModel.fileName, let url = URL(string: "\(baseURL)\(fileURL)") {
            switch self.fileType {
            case .image:
                 whenImage(url)
                break
            default:
                whenVideo(url)
                break
            }
        } else {
            onfailed?()
        }
    }
    // MARK: - Convert string date to MMM dd, yyyy
    class func convertStringToDate(date:String) -> String? {
        let getDateFormatter = DateFormatter()
        getDateFormatter.dateFormat = FormatterDate.defaultDateFormatter.rawValue
        // Display Date formatter
        let displayDateFormat = DateFormatter()
        displayDateFormat.dateFormat = FormatterDate.MMDY.rawValue
        // Convert date into display format
        if let date = getDateFormatter.date(from: "\(date)") {
            return displayDateFormat.string(from: date)
        }
        return nil
    }
}
