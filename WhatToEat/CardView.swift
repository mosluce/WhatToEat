//
//  CardStackView.swift
//  WhatToEat
//
//  Created by 默司 on 2016/11/11.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }

    override func commonSetup() {
        rounded()
        shadow()
    }
    
    func rounded() {
        self.layer.cornerRadius = 4
    }
    
    func shadow() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        
        self.clipsToBounds = false
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        rounded()
        shadow()
    }

}
