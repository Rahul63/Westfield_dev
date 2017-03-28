//
//  DistListViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/15/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class DistListViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
