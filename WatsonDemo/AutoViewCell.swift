//
//  AutoViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/6/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class AutoViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var thumbImageVw: UIImageView!
    @IBOutlet weak var star1ImageVw: UIImageView!
    @IBOutlet weak var star2ImageVw: UIImageView!
    @IBOutlet weak var star3ImageVw: UIImageView!
    @IBOutlet weak var star4ImageVw: UIImageView!
    @IBOutlet weak var star5ImageVw: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
