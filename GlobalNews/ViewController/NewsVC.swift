//
//  NewsVC.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 5/21/17.
//  Copyright © 2017 RM. All rights reserved.
//

import UIKit
import ReactiveKit

class NewsVC: UIViewController {

    @IBOutlet weak var navigationView: ShadowView!
    @IBOutlet weak var newsTableView: UITableView!
    
    var appService = ApplicationService.instance
    var newsArray = [NewsAvailable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        newsArray = appService.newsAvailableArray
        configureNewsTV()
    }
    
    func configureNewsTV() {
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        newsTableView.register(UINib(nibName: "NewsTVCell", bundle: nil), forCellReuseIdentifier: "NewsTVCell")
    }
}

extension NewsVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTVCell", for: indexPath) as! NewsTVCell
        
        cell.logoImageView.image = newsArray[indexPath.row].logoImage
        cell.newsNameLbl.text = newsArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appService.showNewsWallAction.next((model: newsArray[indexPath.row],vc: self))
    }
}
