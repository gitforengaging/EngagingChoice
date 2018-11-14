//
//  ExampleTableViewController.swift
//  EngagingChoice
//
//  Created by KiwiTech on 30/08/18.
//  Copyright © 2018 KiwiTech. All rights reserved.
//

import UIKit
import EngagingChoice

struct ImageDataModel {
    var url:String
    var title:String
    var index:Int
    var name:String
    var sponserBy:String
}

class ExampleTableViewController: UITableViewController {
    @IBOutlet weak var pullToRefresh: UIRefreshControl!
    // MARK: - Data model property
    var modeWithdata = [ImageDataModel]()
    var imagesURLs = [[ImageDataModel]]()
    // MARK: - ViewController Lifecycle method
    var mediaConentmodel = [ECMediaContent]()
    var mediaContentURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // This data used only for demo purpose not for app store content
        modeWithdata.append(ImageDataModel(url: "https://momsall.com/wp-content/uploads/2018/04/The-Boss-Baby.jpg", title: "Boss Babby", index: 0, name: "Boss Babby", sponserBy:"by DreamWorksTV"))
        modeWithdata.append(ImageDataModel(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHD-CZiPZt-bd95akXKDMqICVaxGVYr0GAbN49spvbN0EpznJ2ZQ", title: "How to Train Your Dragon", index: 1, name: "How to Train Your Dragon", sponserBy:"by DreamWorks Animation"))
        modeWithdata.append(ImageDataModel(url: "https://lumiere-a.akamaihd.net/v1/images/open-uri20160107-21163-1uluvkw_9a643c10.jpeg", title: "Rapunzel", index: 2, name: "Rapunzel", sponserBy:"by Disney"))
        modeWithdata.append(ImageDataModel(url: "https://lumiere-a.akamaihd.net/v1/images/r_thegooddinosaur_header_bcfd18b3.jpeg?region=0,0,2048,808", title: "The Good Dinosaur", index: 3, name: "The Good Dinosaur", sponserBy:"by Walt Disney Pictures"))
        modeWithdata.append(ImageDataModel(url: "https://d13ezvd6yrslxm.cloudfront.net/wp/wp-content/images/megamind-trailer-3.jpg", title: "Megamind", index: 4, name: "Megamind", sponserBy:"by DreamWorks Animation"))
        imagesURLs.append(modeWithdata)
        imagesURLs.append(modeWithdata)
        imagesURLs.append(modeWithdata)
        self.getMediaContent()
        // Reload data
        pullToRefresh.addTarget(self, action: #selector(refershData(_:)), for: .valueChanged)
    }
    @objc private func refershData(_ sender: Any) {
        // Fetch Weather Data
        if pullToRefresh.isRefreshing{
            self.getMediaContent()
        } else {
            self.pullToRefresh.endRefreshing()
        }
    }
    
    func getMediaContent()  {
        // Download media Content list
        ECMediaContentManager.shared.contentList(offset: nil, limit: nil) { (mediaContent) in
            if let mediaContent = mediaContent {
                self.mediaConentmodel = mediaContent
                self.tableView.reloadData()
            }
            self.pullToRefresh.endRefreshing()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return imagesURLs.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: TableCellConfig.headerHeight.rawValue))
        headerView.backgroundColor = .white
        let headingLabel = UILabel(frame: CGRect(x: 20, y: 10, width: view.frame.size.width, height: 25))
        // Set heading for seection
        if section == 0 {
            headingLabel.text = "Most Popular"
        } else if section == MediaContentIndex.addAt.rawValue && !mediaConentmodel.isEmpty {
            headingLabel.text = "Engaging Choice"
        } else {
            if mediaConentmodel.isEmpty && section == MediaContentIndex.addAt.rawValue {
                headingLabel.text = "New Releases"
            } else {
                headingLabel.text = "Recommended"
            }
        }
        headingLabel.textColor = .black
        headerView.addSubview(headingLabel)
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableCellConfig.headerHeight.rawValue
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExampleCollectionTableViewCell.cellIdentifier, for: indexPath) as? ExampleCollectionTableViewCell else {
            fatalError("Expected `\(ExampleCollectionTableViewCell.self)` type for reuseIdentifier \(ExampleCollectionTableViewCell.cellIdentifier). Check the configuration in Main.storyboard.")
        }
        cell.didTapDelegate = self
        if indexPath.section == MediaContentIndex.addAt.rawValue && !mediaConentmodel.isEmpty {
            cell.mediaContentModel = self.mediaConentmodel
        } else {
            cell.imagesURLs = imagesURLs[indexPath.section]
        }
        cell.reloadData()
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableCellConfig.cellHeight.rawValue
    }
    var selectedModel:(dummyModel:ImageDataModel?, apiModel:ECMediaContent?)?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailTable" {
            if let destination = segue.destination as? ExampleDetailTableViewController {
                destination.model = selectedModel
                if let enabled = sender as? Bool {
                    destination.enabledPowerBy = enabled
                } else {
                    destination.enabledPowerBy = false
                }
            }
        }
    }
}
extension ExampleTableViewController: TapDelegate {
    func didTapOnButton<C>(cell: ExampleCollectionViewCell?, model: C) {
        self.selectedModel = (model as? ImageDataModel, model as? ECMediaContent)
        self.performSegue(withIdentifier: "detailTable", sender: cell?.coverImageView.enabledPowerBy)
    }
}
enum TableCellConfig: CGFloat {
    case cellHeight = 145
    case headerHeight = 40
}
