//
//  ECOfferViewController.swift
//  FabricSell
//
//  Created by KiwiTech on 25/09/18.
//

import UIKit
import CoreLocation
extension ECOfferViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // stop location manager
        self.locationManager.stopUpdatingLocation()
        self.locatonCallback()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.gridModelView.userCoordinates = locations.first?.coordinate
        // stop location manager
        self.locationManager.stopUpdatingLocation()
        self.locatonCallback()
    }
}
class ECOfferViewController: UIViewController {
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shimmerView: UIImageView!
    var cellheight = EngagingChoiceGridCell.cellHeight.rawValue
    weak var showGridDelegate:OfferGridCompletionDelegate?
    // MARK: - ModelView instance
    fileprivate let gridModelView = ECOfferViewModel()
     // MARK: - Location Manager
    fileprivate let locationManager = CLLocationManager()
     // MARK: - location permission callback
    fileprivate var locatonCallback:(() -> Void) = {}
    // MARK: - Controller Life Cycle method
    override open func viewDidLoad() {
        super.viewDidLoad()
        UIFont.loadFonts()
        headerTitle.font = UIFont(name: "OpenSans-SemiBold", size: 20)
        // Register tableView with Cell identifier
        tableView.register(UINib(nibName: "\(ECOfferTableViewCell.self)", bundle: Bundle.bundle), forCellReuseIdentifier: "\(ECOfferTableViewCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        self.checkLocationPermission {
            self.getOffers()
        }
       
    }
    fileprivate func getOffers() {
        // Get data from ViewModel
        gridModelView.fetchOfferList(success: {
            self.shimmerView.isHidden = true
            // If no data found video will play directly
            if self.gridModelView.offerList.isEmpty {
                self.dismiss(animated: true, completion: {
                    self.showGridDelegate?.didFinishedShowOffer()
                })
                return
            }
            self.tableView.reloadData()
            // Show popUp View
            self.showPopUp()
        }) { (error) in
            self.dismiss(animated: true, completion: {
                self.showGridDelegate?.didFinishedShowOffer()
            })
        }
    }
    func checkLocationPermission(callback:@escaping () -> Void) {
        self.locatonCallback = callback
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            self.promptToAppSettings()
            return
        default:
            break
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    private func promptToAppSettings() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let goToSetting = UIAlertAction(title: "Setting", style: .destructive, handler: { (action) in
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            alert.addAction(okAction)
            alert.addAction(goToSetting)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Show SignUp Form
    fileprivate func showPopUp() {
        if let isPopup = self.gridModelView.pagination?.isPopup, let shouldShow = EngagingChoiceShowPopup(rawValue: isPopup) {
            switch shouldShow {
            case .show:
                DispatchQueue.main.async { ECGridManager.shared.showCompeteProfilePopup(view: self, isGuest: self.isGuest) }
            default:
                break
            }
        }
    }
    // MARK: - fileprivate
    fileprivate var isGuest:EngagingChoiceUserType {
        if let isOtherUser = self.gridModelView.pagination?.isOtheruser, let type = EngagingChoiceUserType(rawValue: isOtherUser) {
            return type
        }
        return EngagingChoiceUserType.new
    }
    // MARK: - close View Button Action
    @IBAction func closeController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Memory Warning
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ECOfferViewController:UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gridModelView.offerList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ECOfferTableViewCell.self)", for: indexPath) as? ECOfferTableViewCell else {
            fatalError("Expected `\(ECOfferTableViewCell.self)` type for reuseIdentifier \(ECOfferTableViewCell.self).")
        }
        let offerModel = gridModelView.offerList[indexPath.row]
        if let fileType = EngagingChoiceFileType(rawValue: offerModel.fileType) {
            switch fileType {
            case .image:
                if let baseURL = gridModelView.pagination?.fileURL, let fileURL = offerModel.fileName, let url = URL(string: "\(baseURL)\(fileURL)")  {
                    cell.bannderImageView.sd_setImage(with: url, placeholderImage: UIImage.cellShimmer, options: .highPriority, completed: nil)
                }
            case .video:
                if let coverImgae = offerModel.coverImage, let url = URL(string: coverImgae) {
                    cell.bannderImageView.sd_setImage(with: url, placeholderImage: UIImage.cellShimmer, options: .highPriority, completed: nil)
                } else {
                    cell.bannderImageView.image = UIImage.cellShimmer
                }
            default:
                break
            }
        }
        cell.setContent(model: offerModel)
        return cell
    }
}
extension ECOfferViewController:UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.tableView.frame.size.height/EngagingChoiceGridCell.numberOfCell.rawValue
        return height
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailGridViewController = EGOfferGridDetailViewController(nibName: "\(EGOfferGridDetailViewController.self)", bundle: Bundle.bundle)
        // Add offer in ModelView and pass in DetailViewController
        self.gridModelView.offerModel = self.gridModelView.offerList[indexPath.row]
        detailGridViewController.gridModelView = self.gridModelView
        detailGridViewController.showGridDelegate = self.showGridDelegate
        // Update view count on server
        ECDownloadManager.shared.updateViewCountOnServer(type: EngagingChoiceTypeValue.offer.rawValue, id: self.gridModelView.offerList[indexPath.row].id)
        // Show View Controller
        self.show(detailGridViewController, sender: self)
    }
}
