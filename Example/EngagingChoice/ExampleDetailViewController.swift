//
//  ExampleDetailTableViewController.swift
//  EngagingChoice
//
//  Created by KiwiTech on 10/09/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import EngagingChoice
import AVKit
class ExampleDetailTableViewController: UITableViewController {
    @IBOutlet weak var poweredbyView: ECPoweredByView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var ProducedBy: UILabel!
    @IBOutlet weak var similarMovieCoverImageView: UIImageView!
    @IBOutlet weak var similarMovieCoverImageView2: UIImageView!
    var model:(dummyModel:ImageDataModel?, apiModel:ECMediaContent?)?
    var enabledPowerBy = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Cover Image
        coverImageView.sd_addActivityIndicator()
        if let dummyModel = model?.dummyModel {
            coverImageView.sd_setImage(with: URL(string:(dummyModel.url)), completed: nil)
            movieName.text = dummyModel.name
            ProducedBy.text = dummyModel.sponserBy
        }
        if let mediaModel = model?.apiModel {
            coverImageView.sd_setImage(with: URL(string:(mediaModel.coverImage)!), completed: nil)
            movieName.text = mediaModel.contentTitle
        }
        poweredbyView.isHidden = !enabledPowerBy
        // tableView delgate and row height estimate
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        // Dummy data
        similarMovieCoverImageView.sd_addActivityIndicator()
        similarMovieCoverImageView.sd_setImage(with: URL(string:"https://lumiere-a.akamaihd.net/v1/images/g_theincredibles2_01_15b5dff7.jpeg?region=102,0,996,560")!, completed: nil)
        similarMovieCoverImageView2.sd_addActivityIndicator()
        similarMovieCoverImageView2.sd_setImage(with: URL(string:"https://i.kym-cdn.com/entries/icons/original/000/022/391/promo322339620.jpg")!, completed: nil)
        // Get Content Detail
        if let id = model?.apiModel?.id {
            ECMediaContentManager.shared.contentDetail(contentId: id) { (conent) in
                self.model?.apiModel = conent
            }
        }
    }
    // MARK: - Dismiss View Action
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Play Video
    @IBAction func playVideo(_ sender: UIButton) {
        if enabledPowerBy {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let email = appDelegate.emailAddres {
                ECGridManager.showOfferList(view: self, email: email) {
                    self.VideoSetup()
                }
            }
        } else {
            VideoSetup()
        }
    }
    func VideoSetup() {
        if let dummyModel = model?.dummyModel, let url = URL(string: dummyModel.videoURL) {
            videoPlay(with: url)
        }
        if let stringURL = model?.apiModel?.fileName, let url = URL(string: stringURL) {
            videoPlay(with: url)
        }
    }
    fileprivate func videoPlay(with url: URL) {
        let player = AVPlayer(url: url)
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        controller.entersFullScreenWhenPlaybackBegins = true
        self.present(controller, animated: true) {
            controller.player?.play()
        }
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
