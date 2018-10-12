//
//  ECDownloadManager.swift
//  EngagingChoice
//
//  Created by KiwiTech on 30/08/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ECDownloadManager: NSObject {
    // MARK: - Class shared instance
    static let shared = ECDownloadManager()
    // MARK: - Make init private
    private override init() {}
    // MARK: - Download Data from server by making a request
    /// This method make request from server and get data from api
    ///
    /// - Parameters:
    ///   - url: API
    ///   - success: It'll return Model object
    ///   - failed: If there is something wrong It'll call failed clouse
    func downloadData<C:Codable>(with url:URL, params:[String:Any]?, modelType:C.Type, success:@escaping(_ data:C?) -> Void, failed:@escaping (_ error:Error?) -> Void) {
        Alamofire.request(url, method: .get, parameters: params ,encoding: URLEncoding.queryString, headers: headers).responseJSON {
            response in
            if let data = response.data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let model = try jsonDecoder.decode(C.self, from: data)
                    success(model)
                }
                catch let error  {
                    failed(error)
                }
            }
        }
    }
    // MARK: - Update ViewCount
    internal func updateViewCountOnServer(type:Int, id:Int)  {
        let stringURL = "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.viewCount.rawValue)"
        guard let url = URL(string: stringURL) else { return }
        Alamofire.request(url, method: .put, parameters: [EngaingChoiceAPIKey.id.rawValue: id, EngaingChoiceAPIKey.type.rawValue: type] ,encoding: URLEncoding.methodDependent, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                debugPrint(response)
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    // MARK: - Update UserInfo
    internal func updateUserInfo(email: String, number:String, success:@escaping() -> Void, failed:@escaping (_ error:String) -> Swift.Void)  {
        guard let url = URL(string: "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.updatUserInfo.rawValue)") else { return }
        let oldEmailAddress = ECGridManager.shared.getEmailAddress == nil ? "" : ECGridManager.shared.getEmailAddress!
        let parameters  = [EngaingChoiceAPIKey.oldEmail.rawValue: oldEmailAddress, EngaingChoiceAPIKey.email.rawValue: email, EngaingChoiceAPIKey.mobile.rawValue: number]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.methodDependent, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                if response.response?.statusCode == EngagingChoiceAPIStatusCode.ok.rawValue {
                    success()
                } else {
                    if let result = response.result.value as? Dictionary<String, Any>, let message = result["detail"] as? String {
                        failed(message)
                    }
                }
                debugPrint(response)
                break
            case .failure(let error):
                failed(error.localizedDescription)
            }
        }
    }
    // MARK: - Update Offer Action
    internal func updateOfferActionOnServer(action: EngagingChoiceOfferAction, offerId: Int, contentId: Int?)  {
        let stringURL = "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.offerAction.rawValue)"
        guard let url = URL(string: stringURL) else { return }
        guard let email = ECGridManager.shared.getEmailAddress else { return }
        let paramters = [EngaingChoiceAPIKey.offerId.rawValue: offerId,
                         EngaingChoiceAPIKey.action.rawValue: action.rawValue,
                         EngaingChoiceAPIKey.contentId.rawValue: contentId ?? "",
                         EngaingChoiceAPIKey.email.rawValue: email] as [String : Any]
        Alamofire.request(url, method: .post, parameters: paramters ,encoding: URLEncoding.methodDependent, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    // MARK: - Create Header using Secret key
    fileprivate var headers:[String: String] {
        var headers = [String: String]()
        if let key = ECGridManager.shared.getSecretKey {
            headers["token"] = key
        }
        return headers
    }
}
