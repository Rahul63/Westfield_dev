//
//  UserViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/15/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var policyNumLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var userImageVw: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
