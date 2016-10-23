//
//  UserTableViewCell.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/20.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var CellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
