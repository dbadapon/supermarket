//
//  PhotoViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/21/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
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
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var result1: UIView!
    @IBOutlet weak var result2: UIView!
    @IBOutlet weak var result3: UIView!
    @IBOutlet weak var result4: UIView!
    
    var firstResultImageUrl = ""
    var secondResultImageUrl = ""
    var thirdResultImageUrl = ""
    var fourthResultImageUrl = ""
    
    var firstPriceValue: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opaqueHeaderLabel.alpha = 0
        blurView.alpha = 0
        opaqueHeaderImage.backgroundColor = Constants.Colors.mainColor
        opaqueHeaderImage.isHidden = true
        
//        UIView.animate(withDuration: 2) {
//            self.opaqueHeaderImage.alpha = 0.5
//            self.opaqueHeaderLabel.alpha = 1.0
//        }
        
//        opaqueHeaderImage.fadeIn(duration: 1, delay: 0, completion: nil)
//        opaqueHeaderLabel.fadeIn(duration: 1, delay: 0, completion: nil)
        
//        animateHeader()
        
        // call this in the completion of animating the header?
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
//        cancelButton.imageView?.tintColor = UIColor.black
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) + 28.5 - 20)
        
        // add ">" to bottom right hand corner
        let nextButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 48.5 - 20, width: 50, height: 50))
        nextButton.setImage(#imageLiteral(resourceName: "arrow"), for: UIControlState())
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.blurView.alpha = 1.0
            // self.opaqueHeaderImage.alpha = 0.5
            self.opaqueHeaderLabel.alpha = 1.0
        }
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
    
    func animateResults() {
        result1.fadeIn(duration: 1, delay: 0.2, completion: nil)
        result2.fadeIn(duration: 1, delay: 0.3, completion: nil)
        result3.fadeIn(duration: 1, delay: 0.4, completion: nil)
        result4.fadeIn(duration: 1, delay: 0.5, completion: nil)
    }
    
    func checkPriceWithName(query: String) {
        
        let baseURL = "http://api.walmartlabs.com/v1/search?query="
        let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
        let newString = query.replacingOccurrences(of: " ", with: "+")
        
        // print (newString)
        let wholeUrl = baseURL + newString + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { (response) in
            if response.result.isSuccess,
                let responseDictionary = response.result.value as? [String: Any] {
                let numberOfItems = responseDictionary["numItems"] as! Int
                
                // number of items from query
                if numberOfItems == 0 {
                    print ("it's not getting a response")
                    // CODE HERE TO REMOVE OPAQUE HEADER!!! OR AT LEAST HIDE IT
                    return
                }
                // at least one result from query
                if numberOfItems > 0 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    let item = itemArray[0]
                    
                    print ("this is the first item: \(item)")
                    
                    var imageEntities: [[String: Any]] = []
                    if let imageData = item["imageEntities"] {
                        print ("okay we just set image entities")
                        imageEntities = imageData as! [[String: Any]]
                    }
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    print ("this is the number of entitities: \(imageEntities.count)")
                    if realEntity == nil && imageEntities.count > 0 {
                        print ("okay we just set the real entity")
                        realEntity = imageEntities[0]
                    }
                    print ("okay this is the real entity \(realEntity)")
                    var imageUrl = ""
                    if let realEntity = realEntity {
                        print ("okay it's about to set the image url")
                        print (realEntity["largeImage"] as! String)
                        imageUrl = realEntity["largeImage"] as! String
                    }
                    self.firstResultImageUrl = imageUrl
                    print ("THIS IS THE IMAGE URL: \(imageUrl)")
                    
                    if self.firstResultImageUrl != "" {
                        let request: URLRequest = URLRequest(url: URL(string: self.firstResultImageUrl)!)
                        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                            if error == nil {
                                self.firstResultImage.image = UIImage(data: data)
                                // I wish you could just set this at the end!
                            }
                        })
                    }
                    self.firstResultName.text = String(describing: item["name"]!)
                    if let firstItemPrice = item["salePrice"] {
                        self.firstPriceValue = firstItemPrice as! Double
                        if self.firstPriceValue! >= 100.0 {
                            self.firstResultPrice.text = "$" + String(describing: Int(self.firstPriceValue!))
                        } else {
                            let formattedString = "$" + String(format: "%.2f", self.firstPriceValue!)
                            self.firstResultPrice.text = formattedString
                        }
                    }
                }
                // more than one result from query
                if numberOfItems > 1 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    let item = itemArray[1]
                    
                    print ("this is the second item: \(item)")
                    
                    var imageEntities: [[String: Any]] = []
                    if let imageData = item["imageEntities"] {
                        imageEntities = imageData as! [[String: Any]]
                    }
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    if realEntity == nil && imageEntities.count > 0 {
                        realEntity = imageEntities[0]
                    }
                    var imageUrl = ""
                    if let realEntity = realEntity {
                        imageUrl = realEntity["largeImage"] as! String
                    }
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
                    if item["salePrice"] != nil {
                        let price = item["salePrice"] as! Double
                        if price >= 100 {
                            self.secondResultPrice.text = "$" + String(describing: Int(price))
                        } else {
                            let formattedString = "$" + String(format: "%.2f", price)
                            self.secondResultPrice.text = formattedString
                        }
                    }
                }
                
                // more than two results from query
                if numberOfItems > 2 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    let item = itemArray[2]
                    
                    var imageEntities: [[String: Any]] = []
                    if let imageData = item["imageEntities"] {
                        imageEntities = imageData as! [[String: Any]]
                    }
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    if realEntity == nil && imageEntities.count > 0 {
                        realEntity = imageEntities[0]
                    }
                    var imageUrl = ""
                    if let realEntity = realEntity {
                        imageUrl = realEntity["largeImage"] as! String
                    }
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
                    if item["salePrice"] != nil {
                        let price = item["salePrice"] as! Double
                        if price >= 100 {
                            self.thirdResultPrice.text = "$" + String(describing: Int(price))
                        } else {
                            let formattedString = "$" + String(format: "%.2f", price)
                            self.thirdResultPrice.text = formattedString
                        }
                    }
                }
                // more than three results from query
                if numberOfItems > 3 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let item = itemArray[3]
                    
                    var imageEntities: [[String: Any]] = []
                    if let imageData = item["imageEntities"] {
                        imageEntities = imageData as! [[String: Any]]
                    }
                    var realEntity: [String: Any]? = nil
                    for entity in imageEntities {
                        let entityType = entity["entityType"] as! String
                        if entityType == "PRIMARY" {
                            realEntity = entity
                            break
                        }
                    }
                    if realEntity == nil && imageEntities.count > 0 {
                        realEntity = imageEntities[0]
                    }
                    var imageUrl = ""
                    if let realEntity = realEntity {
                        imageUrl = realEntity["largeImage"] as! String
                    }
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
                    if item["salePrice"] != nil {
                        let price = item["salePrice"] as! Double
                        if price >= 100 {
                            self.fourthResultPrice.text = "$" + String(describing: Int(price))
                        } else {
                            let formattedString = "$" + String(format: "%.2f", price)
                            self.fourthResultPrice.text = formattedString
                        }
                    }
                }
            }
            self.animateResults()
        } // end of request completion
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPreviewSegue" {
            let dvc = segue.destination as! UINavigationController
            let rootVC = dvc.topViewController as! PreviewViewController
            rootVC.backgroundImage = self.backgroundImage
            rootVC.topMLResult = self.topMLResult
            rootVC.topPrice = self.firstPriceValue
        }
    }
}

