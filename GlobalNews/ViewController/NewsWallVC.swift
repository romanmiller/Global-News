//
//  NewsWallVC.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 6/2/17.
//  Copyright © 2017 RM. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import AlamofireImage

class NewsWallVC: UIViewController {
    
    @IBOutlet weak var navigationView: ShadowView!
    @IBOutlet weak var navigationLogoImageView: UIImageView! {
        didSet {
            navigationLogoImageView.layer.cornerRadius = 15
            navigationLogoImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var navigationTextLabel: UILabel!
    @IBOutlet weak var newsWallTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    let logoImage = Property<UIImage>(#imageLiteral(resourceName: "cnn"))
    let titleText = Property<String>("")
    let newsWallArr = Property<[News]>([News]())
    
    let appService = ApplicationService.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.bind(to: navigationLogoImageView.reactive.image).dispose(in: appService.bag)
        titleText.bind(to: navigationTextLabel.reactive.text).dispose(in: appService.bag)
        backBtn.reactive.tap.map{self}.bind(to: appService.popVC).dispose(in: appService.bag)
        configureNewsTV()
    }
    
    func configureNewsTV() {
        newsWallTableView.delegate = self
        newsWallTableView.dataSource = self
        newsWallTableView.estimatedRowHeight = 400
        newsWallTableView.rowHeight = UITableViewAutomaticDimension
        
        newsWallTableView.register(UINib(nibName: "NewsWallTVCell", bundle: nil), forCellReuseIdentifier: "NewsWallTVCell")
    }
}

extension NewsWallVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsWallArr.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsWallTVCell", for: indexPath) as! NewsWallTVCell
        cell.newsImageView.af_setImage(withURL: URL(string: newsWallArr.value[indexPath.row].urlToImage)!,placeholderImage: #imageLiteral(resourceName: "placeholder_news"))
        cell.titleLbl.text = newsWallArr.value[indexPath.row].title
        cell.textLbl.text = newsWallArr.value[indexPath.row].text
        cell.authorLbl.text = newsWallArr.value[indexPath.row].author
        cell.publishedAtLbl.text = newsWallArr.value[indexPath.row].publishedAt
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: newsWallArr.value[indexPath.row].url)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
