//
//  FlatButton.swift
//  WhatToEat
//
//  Created by 默司 on 2016/11/10.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

@IBDesignable
class FlatButton: UIButton {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.width)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }
    
    func rounded() {
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
    func shadow() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        
        self.clipsToBounds = false
    }
    
    override func commonSetup() {
        rounded()
        shadow()
        
        if self.currentTitle != nil {
            self.parseIcon()
        }
        
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        rounded()
        shadow()
        
        self.parseIcon()
    }
    
    func touchDown() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.75
        }
    }
    
    func touchUp() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
}
