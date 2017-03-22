//
//  UserDetailViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 3/17/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var profleImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    
       
    @IBAction func backButtonPressed(_ sender: Any) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func helpButtonPressed(_ sender: Any) {
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
