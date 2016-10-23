//
//  HairlineView.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/19.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit

class HairlineView : UIView {
    
    // MARK: UINibLoading
    
    override func awakeFromNib() {
        layer.borderColor = backgroundColor?.cgColor
        layer.borderWidth = (1.0 / UIScreen.main.scale) / 2
        backgroundColor = UIColor.clear
    }
}
