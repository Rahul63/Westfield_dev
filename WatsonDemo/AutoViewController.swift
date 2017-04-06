//
//  AutoViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/4/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit
import BoxContentSDK

class AutoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cIndex : Int! = 0
    var itemValue = [BOXItem]()
    @IBOutlet weak var autoTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let boxContent = BOXContentClient.default()
        
        let searchFile = boxContent?.searchRequest(withQuery: "All", in: NSMakeRange(0, 1000))
        
        searchFile?.ancestorFolderIDs = ["0"]
        //searchFile?.fileExtensions = [".pdf","jpg","png"]
        searchFile?.perform(completion: {item in
           // print(" MY Value..\(item.0)")
            self.itemValue = item.0! as! [BOXItem]
            print(self.itemValue)
            self.autoTableView.reloadData()
            for item in 0..<self.itemValue.count{
                
                let itemData = self.itemValue[item]
                print(itemData)
                if self.itemValue[item].isFile{
                    print(self.itemValue[item].name)
                    print(self.itemValue[item].itemDescription)
                }
                else if self.itemValue[item].isBookmark{
                    print(self.itemValue[item].name)
                    
                    let bookMarkItem =  self.itemValue[item] as? BOXBookmark
                    
                    if let currentURL = bookMarkItem?.url.absoluteString {
                        
                        print(currentURL)
                        
                    } else {
                        
                        // request is nil ...
                        
                    }
                    
                    
                    //let descr = ((BOXBookmark)self.itemValue[item]).URL.absoluteString
                    //print(self.itemValue[item].sharedLink)
                }
            }
            
            
        })

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.itemValue.count
    }
    
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var listCell: AutoViewCell!
        
        if (listCell == nil) {
            listCell = (tableView.dequeueReusableCell(withIdentifier: "AutoViewCell") as? AutoViewCell)!
        }
        listCell.selectionStyle = UITableViewCellSelectionStyle.none
        listCell.titleLbl.text = self.itemValue[indexPath.row].name
        listCell.descriptionLbl.text = self.itemValue[indexPath.row].itemDescription ?? "No description Available"
        
        if indexPath.row%2 == 0 {
            listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display3")//UIImage(named:#imageLiteral(resourceName: "display3"))
        }else if indexPath.row%3 == 0 {
            listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display4")//UIImage(named:#imageLiteral(resourceName: "display3"))
        }else{
            listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display2")
        }
        
        
        
        return listCell
        
    }
    
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 106.6//UITableViewAutomaticDimension
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
