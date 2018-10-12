//
//  ECGridView.swift
//  FabricSell
//
//  Created by apple on 01/09/18.
//

import UIKit

open class ECGridView: UIView {
    // Bool variable to show and hide PoweredBy icon
    @IBInspectable open var enabledPowerBy: Bool = false {
        didSet {
            if powerByThumImageView != nil {
                powerByThumImageView.isHidden = !enabledPowerBy
            }
        }
    }
    // UIImageView to show images
    public var coverImageView:UIImageView!
    fileprivate var powerByThumImageView:UIImageView!
    // Local Flag to controll functionality
    fileprivate var shouldSetupConstraints = true
    fileprivate(set) var isSetup = false
    // ContentId shoud set when create gridView
    public var mediaContentId:Int?
    // MARK: - Initialisers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupAccessibility()
        setupConstraints()
        isSetup = true
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Since awakeFromNib can be called multiple times we check to see if setup routines have been called already for safety
        if !isSetup {
            setup()
            setupAccessibility()
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
        // coverImageView to show cover image.
        coverImageView = UIImageView(frame: CGRect.zero)
        coverImageView.backgroundColor = UIColor.gray
        coverImageView.contentMode = self.contentMode
        self.addSubview(coverImageView)
        //  poweredBy Engaging Choice icon | by default it's invisible
        powerByThumImageView = UIImageView(frame: CGRect.zero)
        powerByThumImageView.backgroundColor = UIColor(red: 61/255, green: 106/255, blue: 211/255, alpha: 1.0)
        powerByThumImageView.contentMode = .center
        powerByThumImageView.image = UIImage.poweredByIcon
        powerByThumImageView.isHidden = !enabledPowerBy
        self.addSubview(powerByThumImageView)
    }
    // MARK: - Accessibility
    /**
     Setup for the view's accessibility
     - It is best to use this for static identifiers that will not change at runtime.
     For dynamically generated identifiers or identifiers that will change over time, we recommend doing this in the view controller or view model as appropriate.
     */
    func setupAccessibility() {
        // Abstract method.
    }
    // MARK: - Constraints
    func setupConstraints() {
        if(shouldSetupConstraints) {
            powerByThumImageView.translatesAutoresizingMaskIntoConstraints = false
            coverImageView.translatesAutoresizingMaskIntoConstraints = false
            // AutoLayout constraints
            addConstraint(NSLayoutConstraint(item: powerByThumImageView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 24))
            addConstraint(NSLayoutConstraint(item: powerByThumImageView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: 24))
            addConstraint(NSLayoutConstraint(item: powerByThumImageView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .trailing,
                                             multiplier: 1,
                                             constant:0))
            addConstraint(NSLayoutConstraint(item: powerByThumImageView,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 0))
            // Add CoverImage Constraint
            addConstraint(NSLayoutConstraint(item: coverImageView,
                                             attribute: .top,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0))
            addConstraint(NSLayoutConstraint(item: coverImageView,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .leading,
                                             multiplier: 1,
                                             constant: 0))
            addConstraint(NSLayoutConstraint(item: coverImageView,
                                             attribute: .trailing,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .trailing,
                                             multiplier: 1,
                                             constant: 0))
            addConstraint(NSLayoutConstraint(item: coverImageView,
                                             attribute: .bottom,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .bottom,
                                             multiplier: 1,
                                             constant: 0))
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    // MARK: - Download Image
    /**
     SetImage download image from server and show in ECGridView
     */
    open func setImage(with url:URL) {
        self.coverImageView.image = nil
        self.coverImageView.sd_setImage(with: url, completed: nil)
    }
    // MARK: - Download Image with callback
    /**
     SetImage download image from server with callback and show in ECGridView
     */
    open func setImage(with url:URL, success:@escaping (_ data:Data) -> Void, failed:@escaping (_ error:Error?) -> Void) {
        self.coverImageView.image = nil
        self.coverImageView.sd_setImage(with: url) { (image, error, type, url) in
            if image?.sd_imageData() != nil && error == nil {
                success((image?.sd_imageData())!)
            } else {
                failed(error)
            }
        }
    }
}
