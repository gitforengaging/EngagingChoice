//
//  ECMediaContentManager.swift
//  FabricSell
//
//  Created by KiwiTech on 21/09/18.
//

import UIKit

public class ECMediaContentManager: NSObject {
    // MARK: - Class shared instance
    public static let shared = ECMediaContentManager()
    // MARK: - Make init private
    private override init() {}
    var contentId:Int?
    // MARK: - Make init private
    public func contentList(offset:Int?, limit:Int?, callback:@escaping (_ content:[ECMediaContent]?) -> Void)  {
        // String url address for offerlist
        let stringURL = "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.contentList.rawValue)"
        var params:[String:Any] = [:]
        if let offset = offset {
            params[EngagingChoiceAPIKey.offset.rawValue] = offset
        }
        if let limit = limit {
            params[EngagingChoiceAPIKey.limit.rawValue] = limit
        }
        // Make sure URL is set before making request to server
        guard let url = URL(string: stringURL) else { return }
        // Download data from server
        ECDownloadManager.shared.downloadData(with: url, params: params, modelType: ECMediaContentModel.self, success: { (dataModel) in
            if let list = dataModel?.data {
                callback(list)
            }
        }) { (error) in }
    }
    public func contentDetail(contentId id: Int, callback:@escaping (_ content: ECMediaContent) -> Void) {
        // set content id
        self.contentId = id
        // String url address for offerlist
        let stringURL = "\(EngagingChoiceAPIBaseURL.baseURL)\(EngagingChoiceAPIEndPoint.contentDetail.rawValue)/\(id)"
        guard let url = URL(string: stringURL) else { return }
        // Download data from server
        ECDownloadManager.shared.downloadData(with: url, params: nil, modelType: ECMediaContentDetailModel.self, success: { (dataModel) in
            if let detail = dataModel?.data {
                callback(detail)
            }
        }) { (error) in
        }
    }
}
