//
//  HomeTableViewCell.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/19.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import YYImage
class HomeTableViewCell: UITableViewCell{
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var ActivityNatrueLabel: UILabel!
    @IBOutlet weak var ActivityDate: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var RenCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.image = YYImage().yy_image(byRoundCornerRadius: 6)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
