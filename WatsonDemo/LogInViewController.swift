//
//  LogInViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/10/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInButton.layer.cornerRadius = 3.0
        self.view.backgroundColor = UIColor(netHex:0xd89c54)

        // Do any additional setup after loading the view.
    }
    @IBAction func SignButtonPressed(_ sender: Any) {
        
        if self.userNameField.text == "" && self.passwordField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Username/Password should not be empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let BaseTabVc = storyBoard.instantiateViewController(withIdentifier: "tabbarVC") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = BaseTabVc
            
        }
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        return true
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
