//
//  NewsWallTVCell.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 6/3/17.
//  Copyright © 2017 RM. All rights reserved.
//

import UIKit

class NewsWallTVCell: UITableViewCell {
    
    @IBOutlet weak var contentScreen: UIView! {
        didSet {
            contentScreen.layer.cornerRadius = 5
            contentScreen.clipsToBounds = true
            contentScreen.layer.borderWidth = 1
            contentScreen.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var publishedAtLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
