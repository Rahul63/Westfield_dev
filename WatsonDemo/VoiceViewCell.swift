//
//  VoiceViewCell.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/15/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

protocol voiceCellDelegate
{
    func SendMessageWithSwitchValue(with valueOnOff:String)
}

class VoiceViewCell: UITableViewCell {
    
    var delegate: voiceCellDelegate!

    @IBOutlet weak var voiceOnOffSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func swithToggled(_ sender: Any) {
        
        if voiceOnOffSwitch.isOn {
            self.delegate?.SendMessageWithSwitchValue(with: "on")
        }else{
            self.delegate?.SendMessageWithSwitchValue(with: "off")
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
