//
//  ActivityListTableViewCell.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/22.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit

class ActivityListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var registerBoutton: UIButton!
    @IBOutlet weak var applicantListButton: UIButton!
    @IBOutlet weak var ListButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        registerBoutton.layer.cornerRadius = 8
        applicantListButton.layer.cornerRadius = 8
        ListButton.layer.cornerRadius = 8
        registerBoutton.layer.masksToBounds = true
        applicantListButton.layer.masksToBounds = true
        ListButton.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
