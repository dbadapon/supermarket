//
//  PhotoViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/21/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Alamofire

class PhotoViewController: UIViewController {
    
    var backgroundImage: UIImage!
    var topMLResult: String!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var opaqueHeaderImage: UIImageView!
    @IBOutlet weak var opaqueHeaderLabel: UILabel!
    @IBOutlet weak var firstResultImage: UIImageView!
    @IBOutlet weak var secondResultImage: UIImageView!
    @IBOutlet weak var thirdResultImage: UIImageView!
    @IBOutlet weak var fourthResultImage: UIImageView!
    @IBOutlet weak var firstResultPrice: UILabel!
    @IBOutlet weak var secondResultPrice: UILabel!
    @IBOutlet weak var thirdResultPrice: UILabel!
    @IBOutlet weak var fourthResultPrice: UILabel!
    @IBOutlet weak var firstResultName: UILabel!
    @IBOutlet weak var secondResultName: UILabel!
    @IBOutlet weak var thirdResultName: UILabel!
    @IBOutlet weak var fourthResultName: UILabel!
    
    var firstResultImageUrl = ""
    var secondResultImageUrl = ""
    var thirdResultImageUrl = ""
    var fourthResultImageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(backgroundImage)
        print(topMLResult)
        
        checkPriceWithName(query: topMLResult)
        
        // originally image was coded
        // self.view.backgroundColor = UIColor.gray
        // let backgroundImageView = UIImageView(frame: view.frame)
        // backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        // backgroundImageView.image = backgroundImage
        // view.addSubview(backgroundImageView)
        
        // set background iamge
        backgroundImageView.image = backgroundImage
        
        /*
         // add blur effect on header part
         let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
         let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = opaqueHeaderImage.bounds
         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         view.addSubview(blurEffectView)
         */
        
        //        opaqueHeaderImage.bringSubview(toFront: view)
        //        opaqueHeaderLabel.bringSubview(toFront: view)
        //        firstResultImage.bringSubview(toFront: view)
        //        firstResultPrice.bringSubview(toFront: view)
        //        secondResultImage.bringSubview(toFront: view)
        //        secondResultPrice.bringSubview(toFront: view)
        //        thirdResultImage.bringSubview(toFront: view)
        //        thirdResultPrice.bringSubview(toFront: view)
        //        thirdResultImage.bringSubview(toFront: view)
        //        thirdResultPrice.bringSubview(toFront: view)
        
        // add "x" to top left hand corner
        let cancelButton = UIButton(frame: CGRect(x: 20.0, y: 30.0, width: 20.0, height: 20.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) + 28.5)
        
        // add ">" to bottom right hand corner
        let nextButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 48.5, width: 30.0, height: 25.0))
        nextButton.setImage(#imageLiteral(resourceName: "arrow"), for: UIControlState())
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancel() {
        // originally had this, pic slides down off screen
        // dismiss(animated: true, completion: nil)
        dismiss(animated: false, completion: nil)
    }
    
    @objc func nextAction() {
        // what happens when user clicks next
        performSegue(withIdentifier: "toPreviewSegue", sender: self)
    }
    
    func checkPriceWithName(query: String) {
        
        let baseURL = "http://api.walmartlabs.com/v1/search?query="
        let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
        
        let newString = query.replacingOccurrences(of: " ", with: "+")
        
        print (newString)
        let wholeUrl = baseURL + newString + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let responseDictionary = response.result.value as? [String: Any] {
                
                let numberOfItems = responseDictionary["numItems"] as! Int
                
                // number of items from query
                if numberOfItems == 0 {
                    print ("it's not getting a response")
                    print (response.result.error!)
                }
                // at least one result from query
                if numberOfItems > 0 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let item = itemArray[0]
                    
                    let imageEntities = item["imageEntities"] as! [[String: Any]]
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    
                    if realEntity == nil {
                        realEntity = imageEntities[0]
                    }
                    
                    let imageUrl = realEntity!["largeImage"] as! String
                    self.firstResultImageUrl = imageUrl
                    print ("THIS IS THE IMAGE URL: \(imageUrl)")
                    
                    if self.firstResultImageUrl != "" {
                        let request: URLRequest = URLRequest(url: URL(string: self.firstResultImageUrl)!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                            if error == nil {
                                self.firstResultImage.image = UIImage(data: data)
                            }
                        })
                    }
                    
                    self.firstResultName.text = String(describing: item["name"]!)
                    self.firstResultPrice.text = "$" + String(describing: item["salePrice"]!)
                    print (item["salePrice"]!)
                }
                // more than one result from query
                if numberOfItems > 1 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let item = itemArray[1]
                    
                    let imageEntities = item["imageEntities"] as! [[String: Any]]
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    
                    if realEntity == nil {
                        realEntity = imageEntities[0]
                    }
                    
                    let imageUrl = realEntity!["largeImage"] as! String
                    self.secondResultImageUrl = imageUrl
                    print ("THIS IS THE IMAGE URL: \(imageUrl)")
                    
                    if self.secondResultImageUrl != "" {
                        let request: URLRequest = URLRequest(url: URL(string: self.secondResultImageUrl)!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                            if error == nil {
                                self.secondResultImage.image = UIImage(data: data)
                            }
                        })
                    }
                    
                    self.secondResultName.text = String(describing: item["name"]!)
                    self.secondResultPrice.text = "$" + String(describing: item["salePrice"]!)
                    print (item["salePrice"]!)
                }
                // more than two results from query
                if numberOfItems > 2 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let item = itemArray[2]
                    
                    let imageEntities = item["imageEntities"] as! [[String: Any]]
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    
                    if realEntity == nil {
                        realEntity = imageEntities[0]
                    }
                    
                    let imageUrl = realEntity!["largeImage"] as! String
                    self.thirdResultImageUrl = imageUrl
                    print ("THIS IS THE IMAGE URL: \(imageUrl)")
                    
                    if self.thirdResultImageUrl != "" {
                        let request: URLRequest = URLRequest(url: URL(string: self.thirdResultImageUrl)!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                            if error == nil {
                                self.thirdResultImage.image = UIImage(data: data)
                            }
                        })
                    }
                    
                    self.thirdResultName.text = String(describing: item["name"]!)
                    self.thirdResultPrice.text = "$" + String(describing: item["salePrice"]!)
                    print (item["salePrice"]!)
                }
                // more than three results from query
                if numberOfItems > 3 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let item = itemArray[3]
                    
                    let imageEntities = item["imageEntities"] as! [[String: Any]]
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    
                    if realEntity == nil {
                        realEntity = imageEntities[0]
                    }
                    
                    let imageUrl = realEntity!["largeImage"] as! String
                    self.fourthResultImageUrl = imageUrl
                    print ("THIS IS THE IMAGE URL: \(imageUrl)")
                    
                    if self.fourthResultImageUrl != "" {
                        let request: URLRequest = URLRequest(url: URL(string: self.fourthResultImageUrl)!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                            if error == nil {
                                self.fourthResultImage.image = UIImage(data: data)
                            }
                        })
                    }
                    
                    self.fourthResultName.text = String(describing: item["name"]!)
                    self.fourthResultPrice.text = "$" + String(describing: item["salePrice"]!)
                    print (item["salePrice"]!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPreviewSegue" {
            let dvc = segue.destination as! PreviewViewController
            dvc.backgroundImage = self.backgroundImage
            dvc.topMLResult = self.topMLResult
        }
    }
}

