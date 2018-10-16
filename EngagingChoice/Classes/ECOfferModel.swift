//
//  ECOfferModel.swift
//  EngagingChoice
//
//  Created by KiwiTech on 05/09/18.
//

import UIKit

struct ECOfferModel: Codable {
    var pagination: Pagination?
    var data: [Offers]?
}
struct Pagination: Codable {
    var count: Int?
    var perPage: Int?
    var numberOfPages: Int?
    var fileURL: String?
    var isPopup: Int?
    var joinDays: Int?
    var isOtheruser: Int?
    private enum CodingKeys: String, CodingKey {
        case count
        case perPage = "per_page"
        case numberOfPages = "num_page"
        case fileURL = "file_url"
        case isPopup = "is_popup"
        case joinDays = "join_days"
        case isOtheruser = "is_other_user"
    }
}
struct Offers: Codable {
    var id: Int
    var tracingNumber: String?
    var offerTitle: String?
    var offerDescription: String?
    var offerStartDate: String
    var offerEndDate: String
    var offerURL: String?
    var offerBudget: String?
    var priceEngagement: String?
    var coupanCode: String?
    var numberOfUser: Int?
    var OfferUsesTime: Int?
    var status: Int?
    var fileName: String?
    var fileType: Int
    var discount: String?
    var discountType: Int
    var coverImage: String?
    private enum CodingKeys: String, CodingKey {
        case id
        case tracingNumber = "tracking_number"
        case offerTitle = "offer_title"
        case offerDescription = "offer_description"
        case offerStartDate = "offer_start_date"
        case offerEndDate = "offer_end_date"
        case offerURL = "offer_url"
        case offerBudget = "offer_budget"
        case priceEngagement = "price_engagement"
        case coupanCode = "coupan_code"
        case numberOfUser = "number_of_uses"
        case OfferUsesTime = "offer_uses_time"
        case status
        case fileName = "file_name"
        case fileType = "file_type"
        case discount = "discount"
        case coverImage = "cover_image"
        case discountType = "discount_type"
    }
}
