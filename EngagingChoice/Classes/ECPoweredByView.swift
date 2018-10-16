//
//  ECPoweredByView.swift
//  EngagingChoice
//
//  Created by KiwiTech on 04/09/18.
//

import UIKit

public class ECPoweredByView: UIView {
    // ImageView for EngagingChoice logo and poweredBy test
    fileprivate var engagingchoice:UIImageView!
    fileprivate var poweredBy:UILabel!
    // Local Flag to controll functionality
    fileprivate var shouldSetupConstraints = true
    fileprivate(set) var isSetup = false
    // MARK: - Initialisers
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Since awakeFromNib can be called multiple times we check to see if setup routines have been called already for safety
        if !isSetup {
            self.backgroundColor = UIColor.white
            setup()
            setupConstraints()
            isSetup = true
        }
    }
    // MARK: - Setup
    /**
     Abstract setup method for initial setup of the view and all its subviews.
     Override this function to initialize subviews, set default values, etc.
     */
    func setup() {
        //     poweredBy Engaging Choice icon
        engagingchoice = UIImageView(frame: CGRect.zero)
        engagingchoice.contentMode = .scaleAspectFill
        engagingchoice.image = UIImage.poweredByWithText
        self.addSubview(engagingchoice)
        //     poweredBy Engaging Choice Label
        poweredBy = UILabel(frame: CGRect.zero)
        poweredBy.text = EngagingChoiceName.poweredBy.rawValue
        poweredBy.textColor = UIColor.poweredByColor
        UIFont.loadFonts()
        poweredBy.font = UIFont(name: "OpenSans-LightItalic", size: 8.0)
        self.addSubview(poweredBy)
    }
    // MARK: - Constraints
    /**
     Abstract setup method for the view's constraints.
     Override this function to add layout constraints for all the subviews.
     */
    public func setupConstraints() {
        if(shouldSetupConstraints) {
            engagingchoice.translatesAutoresizingMaskIntoConstraints = false
            poweredBy.translatesAutoresizingMaskIntoConstraints = false
            // AutoLayout constraints
            addConstraint(NSLayoutConstraint(item: engagingchoice,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 15))
            addConstraint(NSLayoutConstraint(item: engagingchoice,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 95))
            addConstraint(NSLayoutConstraint(item: engagingchoice,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant:0))
            addConstraint(NSLayoutConstraint(item: engagingchoice,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: poweredBy,
                                             attribute: .trailing,
                                             multiplier: 1,
                                             constant: 0))
            addConstraint(NSLayoutConstraint(item: poweredBy,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 10))
            addConstraint(NSLayoutConstraint(item: poweredBy,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 44))
            addConstraint(NSLayoutConstraint(item: poweredBy,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .leading,
                                             multiplier: 1,
                                             constant: 2))
            addConstraint(NSLayoutConstraint(item: poweredBy,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: engagingchoice,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0))
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
}
