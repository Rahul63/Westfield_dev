
//
//  SettingsViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/15/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI


class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CNContactViewControllerDelegate,DistributionServiceDelegate,MiscellaneousServiceDelegate,voiceCellDelegate {
    lazy var profileService: MiscellaneousService = MiscellaneousService(delegate:self)
    lazy var distributionService: DistributionListService = DistributionListService(delegate:self)

    @IBOutlet weak var settingsTableView: UITableView!
    var store = CNContactStore()
    var helpView = UIView()
    var helpViewBG = UIView()
    var results : [CNContact] = []
    var userData : [ProfileModel]!
    var distributionListData : NSArray = []
    var distributionSelectData = ["":""]
    var revValue: String?
    var idDvalue: String?
    var isFromVoiceUpdate : Bool?
    var onOffValue : String?
    
    let sharedInstnce = watsonSingleton.sharedInstance
    var idValue = ""
    
    private struct Constants {
        static let lastName = "Smith"
        static let httpMethodGet = "GET"
        static let httpMethodPost = "POST"
        static let nName = "Jane"
        static let statusCodeOK = 200
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.headerView.backgroundColor = UIColor(netHex:0xd89c54)
        let userDataId = UserDefaults.standard.value(forKey: "UserDetail") as! NSArray
        isFromVoiceUpdate = false
        
        print("myUservalue\(userData)")
        
        let dict2 = userDataId[0] as? Dictionary<String,AnyObject>
        
        idValue = (dict2?["_id"] as? String!)!
        
        //self.serviceCallforGettingProfile(With: idValue)
        
        self.navigationController?.navigationBar.isHidden = true
        self.settingsTableView.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false
        
        var frame = CGRect.zero
        frame.size.height = 1
        self.settingsTableView.tableHeaderView = UIView(frame: frame)
        //self.getDistributionListDetail()
        // Do any additional setup after loading the view.
    }
    
    
    
    func getDistributionListDetail()  {
        distributionService.serviceCallforDistributionList(With: idValue)
    }
    
    
    
    func didReceiveDistributionList(withText text: Any, andId Id:String, andRev rev : String ){
        print("distributionList...\(text)")
         revValue = rev
         idDvalue = Id
        self.distributionListData = text as! NSArray
        settingsTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section==2 {
            return self.distributionListData.count+1
        }else{
           return 1
        }
        
    }
    

    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var userCell: UserViewCell!
        var voiceCell: VoiceViewCell!
        var distCell: DistributionViewCell!
        var distListCell: DistListViewCell!
        
        if (indexPath.section == 0) {
            if (userCell == nil) {
                userCell = (tableView.dequeueReusableCell(withIdentifier: "UserViewCell") as? UserViewCell)!
            }
            userCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if (self.userData != nil) {
                
                let tempData = self.userData[0]
                
                userCell.fullNameLbl.text = String(format: "%@ %@",tempData.firstName,tempData.lastName)//self.userData
                //let dict = self.userData[0] as? Dictionary<String,AnyObject>
                userCell.firstNameLbl.text = tempData.firstName
                userCell.policyNumLbl.text = tempData.policyNumber
                userCell.phoneLbl.text = tempData.phoneNumber
                userCell.emailLbl.text = tempData.email
                
//                if ((self.userData["preferredfirstname"]) != nil) {
//                    userCell.fullNameLbl.text = String(format: "%@ %@", (self.userData["preferredfirstname"])!,(self.userData["preferredlastname"])!)
//                    userCell.firstNameLbl.text = self.userData["preferredfirstname"]
//                }
//                
//                if ((self.userData["policynumber"]) != nil) {
//                    userCell.policyNumLbl.text = String(format: "Policy : %@", (self.userData["policynumber"])!)
//                }
//                if ((self.userData["cellphonenumber"]) != nil) {
//                    userCell.phoneLbl.text = self.userData["cellphonenumber"]!
//                }
//                if ((self.userData["email"]) != nil) {
//                    userCell.emailLbl.text  = self.userData["email"]!
//                }
                
                
            }
            
            //userCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            return userCell
        }
            
        else if (indexPath.section == 1) {
            if (voiceCell == nil) {
                voiceCell = (tableView.dequeueReusableCell(withIdentifier: "VoiceViewCell") as? VoiceViewCell)!
            }
            
            if (self.userData != nil) {
                let tempData = self.userData[0]
                if (tempData.voiceValue == "on") {
                    voiceCell.voiceOnOffSwitch.isOn = true
                }else{
                    voiceCell.voiceOnOffSwitch.isOn = false
                }
            }
            
            voiceCell.delegate = self
            voiceCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return voiceCell
        }
        else{
            if indexPath.row==0 {
                if (distCell == nil) {
                    distCell = (tableView.dequeueReusableCell(withIdentifier: "DistributionViewCell") as? DistributionViewCell)!
                }
                distCell.selectionStyle = UITableViewCellSelectionStyle.none
                //distCell.AddDistributionBtn.addTarget(self, action: #selector(self.addContactPressed(_:)) , for: .touchUpInside)
               // userCell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
                
                return distCell
            }else{
                if (distListCell == nil) {
                    distListCell = (tableView.dequeueReusableCell(withIdentifier: "DistListViewCell") as? DistListViewCell)!
                }
                distListCell.selectionStyle = UITableViewCellSelectionStyle.none
                let distDict = self.distributionListData[indexPath.row-1] as? Dictionary<String,AnyObject>
                if ((distDict?["firstname"]as?String) != nil) {
                    distListCell.nameLabel.text = String(format: "%@ %@", (distDict?["firstname"]as?String)!,"")//(distDict?["lastname"]as?String)!)
                    //userCell.firstNameLbl.text = distDict?["preferredfirstname"] as? String!
                }
                distListCell.phoneLabel.text =  distDict?["cellphone"] as? String!
                distListCell.emailLabel.text =  distDict?["email"] as? String!
                
                
                return distListCell
                
            }
        }
        
    }

    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return 56
        }
        else if indexPath.section == 2 {
            if (indexPath.row == 0 ){
                return 56
            }
            else{
               return 90
            }
        }
        else{
           return 167
        }
        
        //return UITableViewAutomaticDimension
    }

    
    
    
    
    @IBAction func addContactPressed(_ sender: AnyObject) {
        
        let contact = CNContact().mutableCopy() as! CNMutableContact
        contact.givenName = ""
        contact.familyName = ""
        
        let controller = CNContactViewController(forNewContact: contact)
        controller.contactStore = store
        controller.delegate = self
        
        
        // enable actions
        controller.allowsActions = true
        
        // disable editing
        //controller.allowsEditing = false
        
        // add cancel button
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(dismissContactVC(_:)))
//        
//        // add flexible space
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        
//        // add to toolbar
//        controller.setToolbarItems([flexibleSpace, cancelButton, flexibleSpace], animated: false)
//        
        // contact view controller must be embedded in navigation controller
        // initialise navigation controller with contact view controller as root
        let navigationVC = UINavigationController.init(rootViewController: controller)//self.navigationController(ro: controller)
        
        // show toolbar
      //  navigationVC.setToolbarHidden(false, animated: false)
        
        // set navigation presentation style
        //navigationVC.modalPresentationStyle = UIModalPresentationStyle.currentContext
        
        // present view controller
        self.present(navigationVC, animated: true, completion: nil)

        
        
        
        
        
    }
    
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissContactVC(_ sender: AnyObject)  {
        
        self.dismiss(animated: true, completion: nil)
        //
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        profileService.serviceCallforGettingProfile(With: idValue)
        
//        UserDefaults.standard.setValue(self.firstNameFld.text, forKey: "frstName")
//        UserDefaults.standard.setValue(self.lastNameFld, forKey: "lastName")
        
        
       
        
        
        
//        let keys = [CNContactGivenNameKey ,CNContactImageDataKey,CNContactPhoneNumbersKey]
//        var message: String!
//        //let request=CNContactFetchRequest(keysToFetch: keys)
//        //let contactsStore = AppDelegate.AppDel.contactStore
//        // Get all the containers
//        var allContainers: [CNContainer] = []
//        do {
//            allContainers = try self.store.containers(matching: nil)
//        } catch {
//            print("Error fetching containers")
//        }
//        
//        
//        
//        // Iterate all containers and append their contacts to our results array
//        for container in allContainers {
//            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
//            
//            do {
//                let containerResults = try self.store.unifiedContacts(matching: fetchPredicate, keysToFetch: keys as [CNKeyDescriptor])
//                self.results.append(contentsOf: containerResults)
//                //self.tableView.reloadData()
//                message="\(self.results.count)"
//            } catch {
//                print("Error fetching results for container")
//            }
//        }
        
        
        
        
        
        
        //let contactStore = CNContactStore()
//        var results: [CNContact] = []
//        do {
//            try self.store.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor])) {
//                (contact, cursor) -> Void in
//                results.append(contact)
//            }
//        }
//        catch{
//            print("Handle the error please")
//        }
        
        print("Contact list....\(results)")
    }
    
    
    func SendMessageWithSwitchValue(with valueOnOff:String){
        print(valueOnOff)
        isFromVoiceUpdate = true
        let tempData = self.userData[0]
        profileService.serviceCallforUserUpdate(withText: tempData.firstName, and: tempData.lastName, and: tempData.phoneNumber, and: tempData.email, and: idValue, and: valueOnOff)
        self.onOffValue = valueOnOff
    }
    
    
    
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        
        let screenSize: CGRect = UIScreen.main.bounds
        helpView = UIView(frame: CGRect(x: 10, y: screenSize.height/2-50, width: screenSize.width - 20, height: 110))
        helpView.layer.cornerRadius = 10
        helpViewBG = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height))
        helpViewBG.backgroundColor = UIColor.gray
        helpViewBG.alpha = 0.4
        helpView.backgroundColor = UIColor.white
        
        
        let cancelButton = UIButton(frame : CGRect(x: screenSize.width-50, y: 03, width: 25, height: 25))
        cancelButton.setImage(#imageLiteral(resourceName: "cancelBtn"), for: .normal)
       // cancelButton.setTitleColor(UIColor.blue, for: .normal)
        //cancelButton.frame = CGRect(x: screenSize.width-50, y: 03, width: 25, height: 25)
        cancelButton.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
        helpView.addSubview(cancelButton)
        
        let label = UILabel(frame: CGRect(x: 10, y: 25, width: screenSize.width - 30, height: 100))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .left
        label.text = "Use the right arrow '>' to edit your profile or distribution list details. You can also turn the voice of Max on or off."
        label.sizeToFit()
        label.textColor = UIColor.black
        helpView.addSubview(label)
        //helpView.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 1.5)
    
        helpView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {() -> Void in
            self.helpView.transform = CGAffineTransform.identity
        }, completion: {(finished: Bool) -> Void in
            self.view.addSubview(self.helpViewBG)
            self.view.addSubview(self.helpView)
            // do something once the animation finishes, put it here
        })
        
    }
    

func pressed(sender: UIButton!) {
    self.helpView.removeFromSuperview()
    self.helpViewBG.removeFromSuperview()
   
}

    @IBAction func SignOutButtonPressed(_ sender: Any) {
        UserDefaults.standard.setValue("", forKey: "UserDetail")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let logInVc = storyBoard.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = logInVc
        
        
    }
    
    
    func didReceiveMessage(withText text: Any){
        print("\(text)")
        
        if isFromVoiceUpdate! {
            let txt = text as! Bool
            isFromVoiceUpdate = false
            if (txt == true) {
                if (self.onOffValue == "on") {
                    print(">>>>>>>>>>>>>>>on")
                    sharedInstnce.isVoiceOn = true
                }else{
                    sharedInstnce.isVoiceOn = false
                }
            }
            //
        }else{
            let userDataValue : NSMutableArray = []
            userDataValue.add(text)
            
            //let userDataValue = ((text as AnyObject).mutablecopy())! as! NSMutableArray
            
            self.userData = ProfileModel.createDataForPeopleView(userDataValue)
            
            // self.userData = (text as? [String : String])!
            settingsTableView.reloadData()
            self.getDistributionListDetail()
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section==2 {
            if indexPath.row>0 {
                let distDict = self.distributionListData[indexPath.row-1] as? Dictionary<String,AnyObject>
                self.distributionSelectData = distDict! as! [String : String]
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let distDetailVc = storyBoard.instantiateViewController(withIdentifier: "DistDetailViewController") as! DistDetailViewController
                distDetailVc.distributionData = distDict! as! [String : String]
                self.navigationController?.pushViewController(distDetailVc, animated: true)
                
                
                
                
                
            }
            
        }
    }
    
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserViewCell" {
            let nextScene =  segue.destination as! UserDetailViewController
            nextScene.userDataValue = self.userData
            nextScene.idValue = self.idValue
        }
        if segue.identifier == "AddDistView" {
            let nextScene2 =  segue.destination as! AddDistViewController
            nextScene2.distListData = self.distributionListData.mutableCopy() as! NSMutableArray
            nextScene2.idValue = self.idValue
            nextScene2.idDvalue = self.idDvalue!
            nextScene2.revValue = self.revValue!
        }
        
        
    }
    
    func parseJsonProfile(json: [String:AnyObject]) {
        
        //self.value = json["docs"] as! [String]
        //let text = json["docs"] as! NSArray
       // self.delegate?.didReceiveDistributionList(withText: text)
        
    }
    

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

/*extension UITabBarController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.items?.forEach({ (item) -> () in
            item.image = item.selectedImage?.imageWithColor(UIColor.redColor()).imageWithRenderingMode(.AlwaysOriginal)
        })
    }
}*/
