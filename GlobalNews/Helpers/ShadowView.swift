//
//  ShadowView.swift
//  GlobalNews
//
//  Created by Roman Stolyarchuk on 6/2/17.
//  Copyright © 2017 RM. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
