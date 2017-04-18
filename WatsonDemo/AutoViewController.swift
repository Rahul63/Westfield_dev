//
//  AutoViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/4/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import UIKit
import BoxContentSDK

protocol AutoViewDelegate
{
    func loadDetailViewForToolBox(with value:String)
    func tableDidSelectCalled()
    
}

class AutoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ToolBoxSearchDelegate {
    var delegate: AutoViewDelegate?
    var helpViewBG = UIView()
    var  indicatorView = ActivityView()
    var cIndex : Int! = 0
    var itemValue = [BOXItem]()
    @IBOutlet weak var autoTableView: UITableView!
    var searching: Bool = false
    var ToolBxV = ToolBoxViewController()
    var SearchData:[BOXItem] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToolBxV.delegate = self
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
        searching = false
        StartAnimating()
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
                self.stopAnimating()
                self.itemValue = item.0! as! [BOXItem]
            }else{
                self.stopAnimating()
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
                        print("myShare UUUURRRLL\(bxLink.url)")
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
    
    
    func searchedWithValue(with value:String){
        print(value)
        searching = true
        let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", value)
        let arr=(itemValue as NSArray).filtered(using: predicate)
        print(arr,arr.count)
        if arr.count > 0
        {
            SearchData.removeAll(keepingCapacity: true)
            SearchData = arr as! [BOXItem]
        }
        else
        {
            SearchData=itemValue
        }
        autoTableView.reloadData()
        
    }
    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searching {
            return self.SearchData.count
        }else{
            return self.itemValue.count
        }
        
    }
    
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var listCell: AutoViewCell!
        
        if searching {
            if (listCell == nil) {
                listCell = (tableView.dequeueReusableCell(withIdentifier: "AutoViewCell") as? AutoViewCell)!
            }
            listCell.selectionStyle = UITableViewCellSelectionStyle.none
            listCell.titleLbl.text = self.SearchData[indexPath.row].name
            listCell.descriptionLbl.text = self.SearchData[indexPath.row].itemDescription ?? "No description Available"
            
            if indexPath.row%2 == 0 {
                listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display3")//UIImage(named:#imageLiteral(resourceName: "display3"))
            }else if indexPath.row%3 == 0 {
                listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display4")//UIImage(named:#imageLiteral(resourceName: "display3"))
            }else{
                listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display2")
            }
            
            
            
            return listCell
        }else{
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
        
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableDidSelectCalled()
        if searching {
            let itemData = self.SearchData[indexPath.row]
            print(itemData)
            print(itemData.jsonData)
            if itemData.isFile{
                print(itemData.name)
                print("my URL link..\(itemData.sharedLink)")
                
                if itemData.sharedLink != nil{
                    let bxLink = itemData.sharedLink as BOXSharedLink
                    print("myShare UUUURRRLL\(bxLink.url)")
                    
                    self.delegate?.loadDetailViewForToolBox(with: String(describing: bxLink.url!))
                }else{
                    showAlert()
                }
                
                
            }
            else if itemData.isBookmark{
                print(itemData.name)
                
                let bookMarkItem =  itemData as? BOXBookmark
                if let currentURL = bookMarkItem?.url.absoluteString {
                    self.delegate?.loadDetailViewForToolBox(with: currentURL)
                    print(currentURL)
                } else {
                    showAlert()
                    // request is nil ...
                    
                }
                
            }else{
                showAlert()
            }

        }else{
            let itemData = self.itemValue[indexPath.row]
            print(itemData)
            print(itemData.jsonData)
            if itemData.isFile{
                print(itemData.name)
                print("my URL link..\(itemData.sharedLink)")
                
                if itemData.sharedLink != nil{
                    let bxLink = itemData.sharedLink as BOXSharedLink
                    print("myShare UUUURRRLL\(bxLink.url)")
                    
                    self.delegate?.loadDetailViewForToolBox(with: String(describing: bxLink.url!))
                }else{
                    showAlert()
                }
                
                
            }
            else if itemData.isBookmark{
                print(itemData.name)
                
                let bookMarkItem =  itemData as? BOXBookmark
                if let currentURL = bookMarkItem?.url.absoluteString {
                    self.delegate?.loadDetailViewForToolBox(with: currentURL)
                    print(currentURL)
                } else {
                    showAlert()
                    // request is nil ...
                    
                }
                
            }else{
                showAlert()
            }

        }
        
        
        
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let detailVc = storyBoard.instantiateViewController(withIdentifier: "ToolBoxDetailViewController") as! ToolBoxDetailViewController
//        
//       
//        
//        detailVc.view.frame = CGRect(x:0,y:0,width: detailVc.view.frame.width,height:detailVc.view.frame.height)
//        
//        let left = CGAffineTransform(translationX: -0, y: 0)
//        let right = CGAffineTransform(translationX: 0, y: 0)
//        let top = CGAffineTransform(translationX: 0, y: -300)
        
        //UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: <#T##UIViewAnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            // Add the transformation in this block
//            // self.container is your view that you want to animate
//            detailVc.view.transform = left
           // self.view.addSubview(detailVc.view)
      //  })
        
       // self.tabBarController?.tabBar.isHidden = true
        
       /// CustomTabBarViewController.tabBar(self)
        //detailVc.urlStr = url
        
        
        
        //self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 94//UITableViewAutomaticDimension
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Detail not available", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    
    
    func StartAnimating() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        helpViewBG = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height))
        helpViewBG.alpha = 0.4
        helpViewBG.backgroundColor = UIColor.darkGray
        
        indicatorView.frame = CGRect(x:0,y:0,width:50,height:50)
        //indicatorView.sizeThatFits(CGSize(width:150,height:150))
        indicatorView.center = self.helpViewBG.center//CGPoint(x:self.view.center,y:self.view)
        indicatorView.lineWidth = 5.0
        indicatorView.strokeColor = .green
        self.view.addSubview(helpViewBG)
        helpViewBG.addSubview(indicatorView)
        indicatorView.startAnimating()
        
        
    }
    func stopAnimating() {
        indicatorView.stopAnimating()
        indicatorView.hidesWhenStopped = true
        helpViewBG.removeFromSuperview()
        indicatorView.removeFromSuperview()
        
        
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
