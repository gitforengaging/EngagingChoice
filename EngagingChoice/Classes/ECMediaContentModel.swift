//
//  ECMediaContentModel.swift
//  FabricSell
//
//  Created by KiwiTech on 21/09/18.
//

import UIKit
struct ECMediaContentModel: Codable {
    var pagination: Pagination?
    var data: [ECMediaContent]?
}
struct ECMediaContentDetailModel: Codable {
    var pagination: Pagination?
    var data: ECMediaContent
}
public struct ECMediaContent: Codable {
    public var id: Int
    public var contentTitle: String?
    public var contentDescription: String?
    var contentStartDate: String?
    var contentEndDate: String?
    var status: Int?
    public var fileName: String?
    public var fileType: Int?
    var userId: Int?
    var range: Int?
    var entireUS: Int?
    public var coverImage: String?
    private enum CodingKeys: String, CodingKey {
        case id
        case contentTitle = "content_title"
        case contentDescription = "content_description"
        case contentStartDate = "content_start_date"
        case contentEndDate = "content_end_date"
        case status
        case fileName = "file_name"
        case fileType = "file_type"
        case userId = "user_id"
        case range
        case entireUS = "entire_us"
        case coverImage = "cover_image"
    }
}
