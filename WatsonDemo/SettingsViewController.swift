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


class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CNContactViewControllerDelegate {

    @IBOutlet weak var settingsTableView: UITableView!
    var store = CNContactStore()
    var helpView = UIView()
    var helpViewBG = UIView()
    var results : [CNContact] = []
    var userData : NSArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = UserDefaults.standard.value(forKey: "UserDetail") as! NSArray
        
        print("myUservalue\(userData)")
        
        self.navigationController?.navigationBar.isHidden = true
        self.settingsTableView.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false
        
        var frame = CGRect.zero
        frame.size.height = 1
        self.settingsTableView.tableHeaderView = UIView(frame: frame)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section==2 {
            return 2
        }else{
           return 1
        }
        
    }
    
//    {
//    "_id" = 1;
//    "_rev" = "11-edf57fd4a37ede649a8bfe56942273f1";
//    firsttimeuser = "";
//    password = pass;
//    policynumber = 3;
//    preferredfirstname = kamal2;
//    preferredlastname = sleiman4;
//    progressId = kjdksadjkadj;
//    providesCellPhones = "";
//    settingsId = lsafjdslkfdsflf;
//    type = profile;
//    username = user;
//    }
    
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
            
            if userData.count>0 {
                
                
                let dict = self.userData[0] as? Dictionary<String,AnyObject>
                
                userCell.fullNameLbl.text = String(format: "%@ %@", (dict?["preferredfirstname"]as?String)!,(dict?["preferredlastname"]as?String)!)
                userCell.firstNameLbl.text = dict?["preferredfirstname"] as? String!
                userCell.policyNumLbl.text = String(format: "Policy : %@", (dict?["policynumber"]as?String)!)
                userCell.phoneLbl.text = dict?["providesCellPhones"] as? String!
                userCell.emailLbl.text  = ""
            }
            
            //userCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            return userCell
        }
            
        else if (indexPath.section == 1) {
            if (voiceCell == nil) {
                voiceCell = (tableView.dequeueReusableCell(withIdentifier: "VoiceViewCell") as? VoiceViewCell)!
            }
            voiceCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return voiceCell
        }
        else{
            if indexPath.row==0 {
                if (distCell == nil) {
                    distCell = (tableView.dequeueReusableCell(withIdentifier: "DistributionViewCell") as? DistributionViewCell)!
                }
                distCell.selectionStyle = UITableViewCellSelectionStyle.none
                distCell.AddDistributionBtn.addTarget(self, action: #selector(self.addContactPressed(_:)) , for: .touchUpInside)
               // userCell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
                
                return distCell
            }else{
                if (distListCell == nil) {
                    distListCell = (tableView.dequeueReusableCell(withIdentifier: "DistListViewCell") as? DistListViewCell)!
                }
                distListCell.selectionStyle = UITableViewCellSelectionStyle.none
                
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

        
        
        
        
        
        
        
       // self.present(controller, animated: true, completion: nil)
        //
        
//        navigationController?
//            .pushViewController(controller, animated: true)
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
    
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        
        let screenSize: CGRect = UIScreen.main.bounds
        helpView = UIView(frame: CGRect(x: 10, y: screenSize.height/2-75, width: screenSize.width - 20, height: 150))
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
        label.text = "Use the right arrow '>' to edit either your profile or distribution list details. You can turn the voice of Max off or and use the text feature. The distribution list will let you send to a group of your choice"
        label.sizeToFit()
        label.textColor = UIColor.black
        helpView.addSubview(label)
    
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
