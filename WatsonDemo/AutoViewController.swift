//
//  AutoViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/4/17.
//  Copyright © 2017 RAHUL. All rights reserved.
//

import UIKit
import BoxContentSDK
import WebImage

protocol AutoViewDelegate
{
    func loadDetailViewForToolBox(with value:String)
    func tableDidSelectCalled()
    
}

class AutoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ToolBoxSearchDelegate,BOXAPIAccessTokenDelegate,MiscellaneousServiceDelegate {
    lazy var tokenService: MiscellaneousService = MiscellaneousService(delegate:self)
    var delegate: AutoViewDelegate?
    var helpViewBG = UIView()
    var  indicatorView = ActivityView()
    var imageSizeScale : CGFloat = 0.7
    var cIndex : Int! = 0
    var boxContent = BOXContentClient()
    //var itemValue = [BOXItem]()
    var videoValue = [BOXItem]()
    @IBOutlet weak var autoTableView: UITableView!
    var searching: Bool = false
    var ToolBxV = ToolBoxViewController()
    var SearchData:[BOXItem] = []
    var isDetailClicked : Bool = false
    let sharedInstnce = watsonSingleton.sharedInstance
    var tokan : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        if sharedInstnce.isToolBoxDetailClicked == false {
            self.sharedInstnce.itemValue.removeAll()
        }
        helpViewBG = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: screenSize.height))
        helpViewBG.alpha = 0.4
        helpViewBG.backgroundColor = UIColor.darkGray
        
        indicatorView.frame = CGRect(x:0,y:0,width:50,height:50)
        indicatorView.center = CGPoint(x: self.view.frame.size.width/2,y: self.view.frame.size.height/2-100)
        indicatorView.lineWidth = 5.0
        indicatorView.strokeColor = UIColor(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1)
        self.view.addSubview(helpViewBG)
        helpViewBG.addSubview(indicatorView)
        helpViewBG.isHidden = true
        ToolBxV.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searching = false
        if sharedInstnce.isToolBoxDetailClicked == false {
           // self.sharedInstnce.itemValue.removeAll()
            StartAnimating()
//            self.getToolBoxData()
            tokenService.getUserAccessTokenForBox()
        }else{
            self.isDetailClicked = false
            sharedInstnce.isToolBoxDetailClicked = false
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAnimating()
    }
    
    //https://account.box.com/api/oauth2/authorize?response_type=code&client_id=2y3f7wr99x1emxgwuaufiwku9km19kna&redirect_uri=boxsdk-2y3f7wr99x1emxgwuaufiwku9km19kna://boxsdkoauth2redirect&state=security_token%3DKnhMJatFipTAnM0nHlZA
    
    func didReceiveMessage(withText text: Any){
        self.tokan = text as! String
        //self.tokan = "HdFX02CbVAJHxWtsyAr5ZUjxAJPN6VZj"
        //stopAnimating()
        self.boxContent = BOXContentClient.default()
        boxContent.accessTokenDelegate = self
        boxContent.authenticate(completionBlock:{(file: BOXUser?, err:Error?) -> Void in
            if (err == nil) {
                //print("logged In\(file?.login)")
                //self.StartAnimating()
                self.getToolBoxData()
            }else{
                //print(err)
            }
        })
    }
    
    
    
    func parseJsonProfile(json: [String:AnyObject]) {
        //
    }
    
    
    public func fetchAccessToken(completion: ((String?, Date?, Error?) -> Void)!) {
        //print("ACESSSSS Token fetcheddd>>>>>>>>>>\(completion)")
        completion(tokan,NSDate.init(timeIntervalSinceNow: 100) as Date,nil)
    }
    

    
    func getToolBoxData() {
        
        //let getHandoutFiles = boxContent?.folderItemsRequest(withID: "23235938513")
        let getVideoFiles = self.boxContent.folderItemsRequest(withID: "23235938001")
        getVideoFiles?.perform(completion: {item in
            if item.0 != nil {
                self.videoValue = item.0! as! [BOXItem]
               // print(self.videoValue)
            }
            self.addHandouts()
        })
        
    }
    
    func addHandouts()  {
        let getHandoutFiles = self.boxContent.folderItemsRequest(withID: "23235938513")
        getHandoutFiles?.perform(completion: {item in
            //print(" MY Value..\(item)")
            if item.0 != nil {
                self.stopAnimating()
                self.sharedInstnce.itemValue = item.0! as! [BOXItem]
                if self.videoValue.count > 0{
                    for item in 0..<self.videoValue.count{
                        self.sharedInstnce.itemValue.append(self.videoValue[item])
                    }
                }
                
            }else{
                self.stopAnimating()
                let alert = UIAlertController(title: "Error", message: "Unable to fetch data", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
           // print(self.sharedInstnce.itemValue)
            self.autoTableView.reloadData()
            
            
        })
    }
    
    
    func searchedWithValue(with value:String){
        print(value)
        searching = true
        if value.characters.count > 0{
            let predicate=NSPredicate(format: "SELF.name CONTAINS[cd] %@", value)
            let arr=(self.sharedInstnce.itemValue as NSArray).filtered(using: predicate)
            print(arr,arr.count)
            if arr.count > 0
            {
                SearchData.removeAll(keepingCapacity: true)
                SearchData = arr as! [BOXItem]
            }
            else
            {
                SearchData.removeAll(keepingCapacity: true)
                //SearchData=itemValue
            }
            autoTableView.reloadData()
        }else{
            SearchData=self.sharedInstnce.itemValue
            autoTableView.reloadData()
        }
        
    }
    
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searching {
            if self.SearchData.count>0{
                return self.SearchData.count
            }else{
               return 1
            }
            
        }else{
            return self.sharedInstnce.itemValue.count
        }
        
    }
    
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var listCell: AutoViewCell!
        
        if searching {
            if self.SearchData.count > 0 {
                if (listCell == nil) {
                    listCell = (tableView.dequeueReusableCell(withIdentifier: "AutoViewCell") as? AutoViewCell)!
                }
                listCell.selectionStyle = UITableViewCellSelectionStyle.none
                //<img:src>https://ibm.box.com/shared/static/fhnw37n5vu3aj67gn1gz27xvipnkslux.jpg</img:src>
                var nameStr : NSString? = self.SearchData[indexPath.row].name as NSString
                listCell.isUserInteractionEnabled = true
                if (nameStr?.contains("<img:src>"))! {
                    let rangeImage = nameStr?.range(of:"<img:src>(.*?)</img:src>", options:.regularExpression)
                    if (rangeImage != nil) {
                        
                        var optionsString = nameStr?.substring(with: rangeImage!)
                        nameStr = nameStr?.replacingOccurrences(of: optionsString!, with: "") as NSString?
                        optionsString = optionsString?.replacingOccurrences(of: "<img:src>", with: "")
                        optionsString = optionsString?.replacingOccurrences(of: "</img:src>", with: "")
                        listCell.thumbImageVw.setShowActivityIndicator(true)
                        listCell.thumbImageVw.contentMode = .scaleAspectFit
                        //print("IMMMAAAGGEEE : \(optionsString)")
                        listCell.thumbImageVw.sd_setImage(with: URL(string : optionsString!)) { (image, error, imageCacheType, imageUrl) in
                            if image != nil {
                                
                            }else
                            {
                                print("image not found")
                            }
                        }
                    }
                }else{
                    listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display4")
                }
                
                listCell.titleLbl.text = nameStr! as String
                listCell.descriptionLbl.text = self.SearchData[indexPath.row].itemDescription ?? "No description Available"
                listCell.thumbImageVw.isHidden = false
                listCell.lineImage.isHidden = false
                
                return listCell
                
            }else{
                if (listCell == nil) {
                    listCell = (tableView.dequeueReusableCell(withIdentifier: "AutoViewCell") as? AutoViewCell)!
                }
                listCell.selectionStyle = UITableViewCellSelectionStyle.none
                listCell.titleLbl.text = "No Record Found"
                listCell.descriptionLbl.text = ""
                listCell.thumbImageVw.isHidden = true
                listCell.lineImage.isHidden = true
                listCell.isUserInteractionEnabled = false
                
                return listCell
            }
            
        }else{
            if (listCell == nil) {
                listCell = (tableView.dequeueReusableCell(withIdentifier: "AutoViewCell") as? AutoViewCell)!
            }
            listCell.selectionStyle = UITableViewCellSelectionStyle.none
            listCell.isUserInteractionEnabled = true
            var nameStr : NSString? = self.sharedInstnce.itemValue[indexPath.row].name as NSString
            listCell.thumbImageVw.contentMode = .scaleAspectFit
            if (nameStr?.contains("<img:src>"))! {
                let rangeImage = nameStr?.range(of:"<img:src>(.*?)</img:src>", options:.regularExpression)
                if (rangeImage != nil) {
                    
                    var optionsString = nameStr?.substring(with: rangeImage!)
                    nameStr = nameStr?.replacingOccurrences(of: optionsString!, with: "") as NSString?
                    optionsString = optionsString?.replacingOccurrences(of: "<img:src>", with: "")
                    optionsString = optionsString?.replacingOccurrences(of: "</img:src>", with: "")
                    listCell.thumbImageVw.setShowActivityIndicator(true)
                    
                    //print("IMMMAAAGGEEE : \(optionsString)")
                    listCell.thumbImageVw.sd_setImage(with: URL(string : optionsString!)) { (image, error, imageCacheType, imageUrl) in
                        if image != nil {
                            listCell.thumbImageVw.image = self.resizeImageWithAspect(image: image!, scaledToMaxWidth: (image?.size.width)!*self.imageSizeScale, maxHeight: (image?.size.height)!*self.imageSizeScale)
                            listCell.thumbImageVw.sizeToFit()
                        
                        }else
                        {
                            print("image not found")
                        }
                    }
                }
            }else{
                listCell.thumbImageVw.image = UIImage.init(imageLiteralResourceName: "display4")
            }
            listCell.thumbImageVw.isHidden = false
            listCell.lineImage.isHidden = false
            listCell.titleLbl.text = nameStr! as String//self.sharedInstnce.itemValue[indexPath.row].name
            listCell.descriptionLbl.text = self.sharedInstnce.itemValue[indexPath.row].itemDescription ?? "No description Available"
            
            
            return listCell
        }
        
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableDidSelectCalled()
        self.isDetailClicked = true
        sharedInstnce.isToolBoxDetailClicked = true
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
            let itemData = self.sharedInstnce.itemValue[indexPath.row]
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
        
        
    }
    
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 94//UITableViewAutomaticDimension
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Detail not available", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage
    {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width:newWidth, height:newHeight);
        
        return resizeImage(image: image, targetSize: newSize)//(image, size: newSize);
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func StartAnimating() {
        helpViewBG.isHidden = false
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
    

   
}
