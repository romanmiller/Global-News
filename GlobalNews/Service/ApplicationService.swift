//
//  ApplicationService.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 5/21/17.
//  Copyright © 2017 RM. All rights reserved.
//

import UIKit
import ReactiveKit

struct NewsAvailable {
    let tag: String
    let name: String
    let logoImage: UIImage
    
    init(tag: String,name: String,logoImage: UIImage) {
        self.tag = tag
        self.name = name
        self.logoImage = logoImage
    }
}

class ApplicationService {
    
    var bag = DisposeBag()
    
    static let instance = ApplicationService()
    
    let newsClient = NewsClient()
    
    public let showNewsWallAction = SafePublishSubject<(model: NewsAvailable, vc: UIViewController)>()
    public let popVC = SafePublishSubject<UIViewController>()
    
    let newsAvailableArray = [NewsAvailable(tag: "cnn",name: "CNN",logoImage: #imageLiteral(resourceName: "cnn")),NewsAvailable(tag: "the-guardian-uk",name: "The Guardian UK",logoImage: #imageLiteral(resourceName: "guardians")),NewsAvailable(tag: "the-new-york-times",name: "The New York Times",logoImage: #imageLiteral(resourceName: "newYorkTimes")),NewsAvailable(tag: "bbc-news",name: "BBC News",logoImage: #imageLiteral(resourceName: "bbc_news")),NewsAvailable(tag: "bbc-sport",name: "BBC Sport",logoImage: #imageLiteral(resourceName: "bbc_sport")),NewsAvailable(tag: "google-news",name: "Google News",logoImage: #imageLiteral(resourceName: "google_news")),NewsAvailable(tag: "techcrunch",name: "TechCrunch",logoImage: #imageLiteral(resourceName: "tech_crunch"))]
    
    
    func bootStrap() {
        
        showNewsWallAction.observeNext { [weak self] (model,vc) in
            guard let sself = self else {return}
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            vc.view.isUserInteractionEnabled = false
            sself.newsClient.news(name: model.tag).onSuccess { news in
                if let newsWallVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsWallVC") as? NewsWallVC {
                    newsWallVC.logoImage.next(model.logoImage)
                    newsWallVC.titleText.next(model.name)
                    newsWallVC.newsWallArr.next(news)
                    vc.navigationController?.pushViewController(newsWallVC, animated: true)
                }
            }.onFailure { error in
                let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alertVC.addAction(okAction)
                vc.present(alertVC, animated: true, completion: nil)
            }.onComplete { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                vc.view.isUserInteractionEnabled = true
            }
        }.dispose(in: bag)
        
        popVC.observeNext { vc in
            vc.navigationController?.popViewController(animated: true)
        }.dispose(in: bag)
    }
}


