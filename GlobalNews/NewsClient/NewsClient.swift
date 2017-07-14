//
//  NewsClient.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 5/21/17.
//  Copyright © 2017 RM. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import SwiftyJSON
import BrightFutures
import ReactiveKit

struct News {
    let author: String
    let title: String
    let text: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    
    init(author: String = "", title: String = "",text: String = "",url: String = "",urlToImage: String = "",publishedAt: String = "") {
        self.author = author
        self.title = title
        self.text = text
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
}

class NewsClient {
    let apiKey = "31f1902fda81449dbcce79c847138dfa"
    let baseUrl = "https://newsapi.org/v1/"
    
    var sessionManager = SessionManager()
    
    private func _url(method:String, arguments:[String:String]? = nil) -> URL {
        let base = URL(string: baseUrl)!
            .appendingPathComponent(method).absoluteString
        
        let query = arguments.map { arguments in
            arguments.reduce("") { z, a in
                let (key, value) = a
                let part = key + "=" + value
                let delimeter = z.isEmpty ? "?" : "&"
                return z + delimeter + part
            }
            } ?? ""
        
        return URL(string: base + query)!
    }
    
    private func parseArticles(json: JSON) -> [News] {
        if let articles = json["articles"].array {
        return articles.flatMap { js in
            
                let author = js["author"].string ?? ""
                let title = js["title"].string ?? ""
                let text = js["description"].string ?? ""
                let url = js["url"].string ?? ""
                let urlToImage = js["urlToImage"].string ?? ""
                let publishedAt = js["publishedAt"].string ?? ""
            
                return News(author:author,title: title,text:text,url: url,urlToImage: urlToImage,publishedAt: publishedAt)
            }
        }
        return [News(author: "",title: "",text: "",url: "",urlToImage: "",publishedAt: "")]
    }
    
    func news(name: String) -> Future<[News],NSError> {
        let args = ["apiKey" : apiKey,"source" : name]
        let url = _url(method: "articles", arguments: args)
        
        let promise = Promise<[News],NSError>()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(10)
        sessionManager = SessionManager(configuration: configuration)
        
        sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    promise.success(self.parseArticles(json: JSON.init(value)))
                case .failure(let error):
                    promise.failure(error as NSError)
                }
            }.session.configuration.timeoutIntervalForResource = 5
        return promise.future
    }
}
