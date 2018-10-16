//
//  ECOfferTableViewCell.swift
//  EngagingChoice
//
//  Created by KiwiTech on 25/09/18.
//

import UIKit

class ECOfferTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var bannderImageView: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerPercentage: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var offerOff: UILabel!
    // MARK: - Outlets Constraint
    @IBOutlet weak var titleHeightContraint: NSLayoutConstraint!
    // MARK: - awakeFromNib
    override open func awakeFromNib() {
        super.awakeFromNib()
        fontSetup()
    }
    // MARK: - Cell Lifecyle
    open override func layoutSubviews() {
        super.layoutSubviews()
        offerTitle.numberOfLines = 0;
        offerTitle.sizeToFit()
    }
    // MARK: - Set details
    func setContent(model: Offers) {
        offerTitle.text = model.offerTitle
        offerPercentage.text = model.discount
        if let discountType = EngagingChoiceDiscountType(rawValue: model.discountType) {
            switch discountType {
            case .buyOneGetOne:
                offerOff.isHidden = true
            default:
                offerOff.isHidden = false
                break
            }
        }
        if let offerEndDate =  ECOfferViewModel.convertStringToDate(date: model.offerEndDate) {
            subTitle.text = "\(EngagingChoiceName.validTill.rawValue) \(String(describing: offerEndDate))"
        }
    }
    // MARK: - Load Fonts
    private func fontSetup() {
        UIFont.loadFonts()
        offerTitle.font = UIFont(name: "OpenSans-SemiBold", size: 19)
        offerPercentage.font = UIFont(name: "OpenSans-Bold", size: 22)
        offerOff.font = UIFont(name: "OpenSans-Regular", size: 13)
    }
}
