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
        boxContent?.authenticate(completionBlock:{(file: BOXUser?, err:Error?) -> Void in
            if (err == nil) {
                print("logged In\(file?.login)")
            }else{
                //print(err)
            }
        })
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getToolBoxData()
    }
    
    
    func getToolBoxData() {
        let boxContent = BOXContentClient.default()
        
        let searchFile = boxContent?.searchRequest(withQuery: "All", in: NSMakeRange(0, 1000))
        
        searchFile?.ancestorFolderIDs = ["0"]
        //searchFile?.fileExtensions = [".pdf","jpg","png"]
        searchFile?.perform(completion: {item in
            print(" MY Value..\(item)")
            if item.0 != nil {
                self.itemValue = item.0! as! [BOXItem]
            }else{
                let alert = UIAlertController(title: "Error", message: "Unable to fetch data", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            print(self.itemValue)
            self.autoTableView.reloadData()
            for item in 0..<self.itemValue.count{
                
                let itemData = self.itemValue[item]
                print(itemData)
                if self.itemValue[item].isFile{
                    print(self.itemValue[item].name)
                    print("my URL link..\(self.itemValue[item].sharedLink)")
                    
                    if self.itemValue[item].sharedLink != nil{
                        let bxLink = self.itemValue[item].sharedLink as BOXSharedLink
                        print("myShare UUUURRRLL\(bxLink.downloadURL)")
                    }
                    
                    
                    
                    print(self.itemValue[item].jsonData)
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
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let detailVc = storyBoard.instantiateViewController(withIdentifier: "ToolBoxDetailViewController") as! ToolBoxDetailViewController
//        //detailVc.urlStr = url
//        
//        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 94//UITableViewAutomaticDimension
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
