//
//  NewsTVCell.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 5/27/17.
//  Copyright © 2017 RM. All rights reserved.
//

import UIKit

class NewsTVCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.layer.cornerRadius = 5
            logoImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
