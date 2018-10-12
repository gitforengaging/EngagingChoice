//
//  EGOfferGridDetailViewController.swift
//  FabricSell
//
//  Created by KiwiTech on 05/09/18.
//

import UIKit
import AVKit
import SafariServices
class EGOfferGridDetailViewController: UIViewController, AVPlayerViewControllerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var viewLayerView: VideoContainerView!
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var offerPercentage: UILabel!
    @IBOutlet weak var offerOff: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Private Properties
    private var videoPlayer:AVPlayer?
    private var isPlaying = false
    // MARK: - Delegate Properties
    weak var showGridDelegate:OfferGridCompletionDelegate?
    // MARK: - MMVM - ModelView
    var gridModelView:ECOfferViewModel?
    // MARK: - Controller Lifcyle func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fontSetup()
        self.offerDescription.sizeToFit()
        self.offerDescription.numberOfLines = 0
        self.setContent()
        self.gridModelView?.createFileURL(whenImage: { (url) in
            self.playPauseButton.isHidden = true
            // Hide VideoPlayer Content View
            self.viewLayerView.isHidden = true
            // Stop indicator
            self.activityIndicator.stopAnimating()
            self.coverImageView.sd_setImage(with: url, completed: nil)
        }, whenVideo: { (url) in
            self.overlayImageView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.createVideoPlayer(url: url)
            }
        }, onfailed: nil)
    }
    // MARK: - Deinit
    deinit {
        // Remove observer to not call oberver when viewDisappear
        videoPlayer?.removeObserver(self, forKeyPath: "status", context: nil)
    }
    // MARK: - Video Player
    fileprivate func createVideoPlayer(url: URL)  {
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        videoPlayer = AVPlayer(url: url)
        videoPlayer?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = .resizeAspectFill;
        playerLayer.frame = self.viewLayerView.bounds;
        self.viewLayerView.layer.addSublayer(playerLayer)
        self.viewLayerView.playerLayer = playerLayer
        if videoPlayer != nil {
            self.controllerPlay()
            self.isPlaying = true
        }
    }
    // MARK: - AVPlayer status observer for stop Indicator View
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer {
            if player == videoPlayer && keyPath == "status" {
                switch player.status {
                case .readyToPlay:
                    // Add Tap gesture to Play/pause Video
                    self.addTapGesture()
                    // Stop indicator when video start playing
                    self.activityIndicator.stopAnimating()
                    break
                default:
                    break
                }
            }
        }
    }
     // MARK: - Tap Gesture hide/show play button
    fileprivate func addTapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.viewLayerView.isUserInteractionEnabled = true
        self.viewLayerView.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        switch self.playPauseButton.isHidden {
        case true:
            changeOpacity(value: 1.0)
        default:
            changeOpacity(value: 0.0)
        }
    }
    fileprivate func changeOpacity(value:CGFloat) {
        UIView.animate(withDuration: 0.7) {
            self.playPauseButton.alpha = value
            self.playPauseButton.isHidden = !self.playPauseButton.isHidden
        }
    }
    // MARK: - Set details
    fileprivate func setContent() {
        offerTitle.text = gridModelView?.offerModel.offerTitle
        offerPercentage.text = gridModelView?.offerModel.discount
        if gridModelView?.offerModel.discountType == 1 {
            offerOff.isHidden = true
        } else {
            offerOff.isHidden = false
        }
        offerDescription.text = gridModelView?.offerModel.offerDescription
    }
    // MARK: - Load Fonts
    fileprivate func fontSetup() {
        UIFont.loadFonts()
        offerTitle.font = UIFont(name: "OpenSans-SemiBold", size: 19)
        offerPercentage.font = UIFont(name: "OpenSans-Bold", size: 22)
        offerOff.font = UIFont(name: "OpenSans-Regular", size: 13)
    }
    fileprivate func controllerPlay()  {
        if !self.isPlaying {
            videoPlayer?.play()
            self.playPauseButton.setImage(UIImage.pauseImage, for: .normal)
            handleTap(nil)
        } else {
            videoPlayer?.pause()
            self.playPauseButton.setImage(UIImage.playImage, for: .normal)
        }
    }
    // MARK: - PlayPause Action
    @IBAction func playPause(_ sender: UIButton) {
        controllerPlay()
        self.isPlaying = !self.isPlaying
    }
    // MARK: - Later Action
    @IBAction func later(_ sender: Any) {
        self.gridModelView?.updateOfferAction(action: .later)
        self.sendBackToDetailController()
    }
    // MARK: - Skip Action
    @IBAction func skip(_ sender: UIButton) {
        self.gridModelView?.updateOfferAction(action: .skip)
        self.sendBackToDetailController()
    }
    // MARK: - Get Offer
    @IBAction func getOffer(_ sender: Any) {
        self.gridModelView?.updateOfferAction(action: .getOffer)
        if let stringURL = self.gridModelView?.offerModel.offerURL, let url = URL(string: stringURL) {
            let controller = SFSafariViewController(url: url)
            controller.delegate = self
            self.present(controller, animated: true) {
            }
        }
    }
    // MARK: - Close Action
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func sendBackToDetailController() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.showGridDelegate?.didFinishedShowOffer()
        })
    }
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // Remove Video Controller from memory if it receive memory warning
    }
}

extension EGOfferGridDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.sendBackToDetailController()
    }
}
