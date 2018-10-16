//
//  ExampleCollectionTableViewCell.swift
//  EngagingChoice
//
//  Created by KiwiTech on 30/08/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import EngagingChoice

protocol TapDelegate: NSObjectProtocol {
    func didTapOnButton<C>(cell: ExampleCollectionViewCell?, model: C)
}
class ExampleCollectionTableViewCell: UITableViewCell {
    // MARK: - Static cell property
    static let cellIdentifier = "collectionCell"
    // MARK: - collectionView Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - Dummy Object Model
    var imagesURLs = [ImageDataModel]()
    // MARK: - Dummy Object Model
    var mediaContentModel = [ECMediaContent]()
    var mediaBaseURL:String?
    // MARK: - Tap Delegate
    weak var didTapDelegate:TapDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // MARK: - Reload data
    func reloadData() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
extension ExampleCollectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !mediaContentModel.isEmpty {
            return mediaContentModel.count
        }
        return imagesURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExampleCollectionViewCell.cellIdentifier, for: indexPath) as? ExampleCollectionViewCell else {
            fatalError("Expected `\(ExampleCollectionViewCell.self)` type for reuseIdentifier \(ExampleCollectionViewCell.cellIdentifier). Check the configuration in Main.storyboard.")
        }
        cell.coverImageView.coverImageView.image = nil
        if mediaContentModel.isEmpty {
            if imagesURLs[indexPath.row].index == MediaContentIndex.addAt.rawValue {
                cell.coverImageView.enabledPowerBy = false
            } else {
                cell.coverImageView.enabledPowerBy = true
            }
            cell.coverImageView.setImage(with: URL(string: imagesURLs[indexPath.row].url)!, success: { (data) in
                
            }) { (error) in
                
            }
        } else {
            let mediaContent = self.mediaContentModel[indexPath.row]
            cell.coverImageView.enabledPowerBy = true
            cell.coverImageView.mediaContentId = mediaContent.id
            if let urlString = mediaContent.coverImage, let url = URL(string: "\(urlString)") {
                cell.coverImageView.setImage(with: url)
            }
        }
        return cell
    }
}
extension ExampleCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ExampleCollectionViewCell
        if mediaContentModel.isEmpty {
            didTapDelegate?.didTapOnButton(cell: cell, model: imagesURLs[indexPath.row])
        } else {
            didTapDelegate?.didTapOnButton(cell: cell, model: self.mediaContentModel[indexPath.row])
        }
    }
}
enum MediaContentIndex: Int {
    case addAt = 1
}
