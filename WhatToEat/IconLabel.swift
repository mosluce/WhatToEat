//
//  IconLabel.swift
//  WhatToEat
//
//  Created by 默司 on 2016/11/10.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit
import SwiftIconFont

@IBDesignable
class IconLabel: UILabel {

    override var text: String? {
        didSet {
            parseIcon()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }
    
    override func commonSetup() {
        if self.text != nil {
            parseIcon()
        }
    }

}
