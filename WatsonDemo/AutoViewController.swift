//
//  AutoViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/4/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class AutoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
//    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        
//        return 1
//    }
//    
//    
//    
//    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var userCell: UserViewCell!
//        var voiceCell: VoiceViewCell!
//        var distCell: DistributionViewCell!
//        var distListCell: DistListViewCell!
//        
//        if (indexPath.section == 0) {
//            if (userCell == nil) {
//                userCell = (tableView.dequeueReusableCell(withIdentifier: "UserViewCell") as? UserViewCell)!
//            }
//            userCell.selectionStyle = UITableViewCellSelectionStyle.none
//            
//            if (self.userData != nil) {
//                
//                let tempData = self.userData[0]
//                
//                userCell.fullNameLbl.text = String(format: "%@ %@",tempData.firstName,tempData.lastName)//self.userData
//                //let dict = self.userData[0] as? Dictionary<String,AnyObject>
//                userCell.firstNameLbl.text = tempData.firstName
//                userCell.policyNumLbl.text = tempData.policyNumber
//                userCell.phoneLbl.text = tempData.phoneNumber
//                userCell.emailLbl.text = tempData.email
//                
//            }
//            
//            
//            return userCell
//        }
//            
//        else if (indexPath.section == 1) {
//            if (voiceCell == nil) {
//                voiceCell = (tableView.dequeueReusableCell(withIdentifier: "VoiceViewCell") as? VoiceViewCell)!
//            }
//            
//            if (self.userData != nil) {
//                let tempData = self.userData[0]
//                if (tempData.voiceValue == "on") {
//                    voiceCell.voiceOnOffSwitch.isOn = false
//                }else{
//                    voiceCell.voiceOnOffSwitch.isOn = true
//                }
//            }
//            
//
//            voiceCell.delegate = self
//            voiceCell.selectionStyle = UITableViewCellSelectionStyle.none
//            
//            return voiceCell
//        }
//        else{
//            if indexPath.row==0 {
//                if (distCell == nil) {
//                    distCell = (tableView.dequeueReusableCell(withIdentifier: "DistributionViewCell") as? DistributionViewCell)!
//                }
//                distCell.selectionStyle = UITableViewCellSelectionStyle.none
//                //distCell.AddDistributionBtn.addTarget(self, action: #selector(self.addContactPressed(_:)) , for: .touchUpInside)
//                // userCell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
//                
//                return distCell
//            }else{
//                if (distListCell == nil) {
//                    distListCell = (tableView.dequeueReusableCell(withIdentifier: "DistListViewCell") as? DistListViewCell)!
//                }
//                distListCell.selectionStyle = UITableViewCellSelectionStyle.none
//                let distDict = self.distributionListData[indexPath.row-1] as? Dictionary<String,AnyObject>
//                if ((distDict?["firstname"]as?String) != nil) {
//                    distListCell.nameLabel.text = String(format: "%@ %@", (distDict?["firstname"]as?String)!,"")//(distDict?["lastname"]as?String)!)
//                    //userCell.firstNameLbl.text = distDict?["preferredfirstname"] as? String!
//                }
//                distListCell.phoneLabel.text =  distDict?["cellphone"] as? String!
//                distListCell.emailLabel.text =  distDict?["email"] as? String!
//                
//                
//                return distListCell
//                
//            }
//        }
//        
//    }
//    
//    
//    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if indexPath.section == 1 {
//            return 56
//        }
//        else if indexPath.section == 2 {
//            if (indexPath.row == 0 ){
//                return 56
//            }
//            else{
//                return 90
//            }
//        }
//        else{
//            return 167
//        }
//        
//        //return UITableViewAutomaticDimension
//    }

    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
