//
//  PriceViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Alamofire
import SimpleAnimation
import NVActivityIndicatorView

class PriceViewController: UIViewController, UITextFieldDelegate {
    
    // for query using itemName
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
    
    // to receive from preview vc
    var itemName: String!
    var coverPhoto: UIImageView!
    var imageOne: UIImageView!
    var imageTwo: UIImageView!
    var imageThree: UIImageView!
    var imageFour: UIImageView!
    
    // to pass onto next vc
    var isNegotiable: Bool!
    var itemPrice: Double!
    
    // color to use for app
    let textColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha:1.0)
    
    // alert controllers
    let priceAlertController = UIAlertController(title: "Invalid Price", message: "Please set a valid price", preferredStyle: .alert)
    let nextAlertController = UIAlertController(title: "Price Required", message: "Please set a price to continue", preferredStyle: .alert)
    
    @IBOutlet weak var inputPrice: UITextField!
    
    @IBOutlet weak var negotiableSwitch: UISwitch!
    
    @IBOutlet weak var priceComparsionsLabel: UILabel!
    
    // Result views
    @IBOutlet weak var resultView1: UIView!
    @IBOutlet weak var resultView2: UIView!
    @IBOutlet weak var resultView3: UIView!
    @IBOutlet weak var resultView4: UIView!
    
    
    
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        if (inputPrice.text != "" && inputPrice.text != nil) {
            performSegue(withIdentifier: "toDescriptionSegue", sender: self)
        } else {
            self.present(self.nextAlertController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide results before they load
        hideResults()
        
        // style navigation bar
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        self.title = "Price"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // make navbar translucent (remove bottom line)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // style text field
        
        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 7, height: 26))
        
        inputPrice.leftView = leftView
        inputPrice.leftViewMode = UITextFieldViewMode.always
        
        inputPrice.layer.cornerRadius = 5
        inputPrice.layer.borderWidth = 1
        inputPrice.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 0.50).cgColor
        
        
        // style next button
        nextButton.layer.cornerRadius = 5
        
        
        // make query
        checkPriceWithName(query: itemName)
        
        // set color of negotiable switch
        negotiableSwitch.onTintColor = textColor
        negotiableSwitch.tintColor = textColor
        
        inputPrice.keyboardType = UIKeyboardType.decimalPad
        inputPrice.tintColor = textColor
        inputPrice.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PriceViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        
        // add the OK action to the alert controller
        priceAlertController.addAction(OKAction)
        nextAlertController.addAction(OKAction)
        
        priceComparsionsLabel.fadeIn(duration: 1.2, delay: 0, completion: nil)
//        comparisonAnimation()
        
    }
    
    func hideResults() {
        resultView1.isHidden = true
        resultView2.isHidden = true
        resultView3.isHidden = true
        resultView4.isHidden = true
    }
    
    func showResults() {
        resultView1.isHidden = false
        resultView2.isHidden = false
        resultView3.isHidden = false
        resultView4.isHidden = false
    }
    
    func comparisonAnimation() {
        
        resultView1.fadeIn(duration: 1, delay: 0.2, completion: nil)
        resultView1.slideIn(from: .bottom, duration: 1, delay: 0.2, completion: nil)
        
        resultView2.fadeIn(duration: 1, delay: 0.4, completion: nil)
        resultView2.slideIn(from: .bottom, duration: 1, delay: 0.4, completion: nil)
        
        resultView3.fadeIn(duration: 1, delay: 0.6, completion: nil)
        resultView3.slideIn(from: .bottom, duration: 1, delay: 0.6, completion: nil)
        
        resultView4.fadeIn(duration: 1, delay: 0.8, completion: nil)
        resultView4.slideIn(from: .bottom, duration: 1, delay: 0.8, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                // Show and animate results
                self.showResults()
                self.comparisonAnimation()
                
            } // End of closure
        }
    }

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field ended editing")
        
        let text = inputPrice.text!
        let num = Double(inputPrice.text!)
        let count = text.characters.count
        
        if inputPrice == nil {
            // do nothing
            // don't want alert controllers popping up
            // every time user taps out of textbox
        } else if count <= 38 && num != nil {
            // value is okay
            self.itemPrice = num
            
            let price = Double(inputPrice.text!)! as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            // formatter.locale = NSLocale.currentLocale() // This is the default
            // In Swift 4, this ^ has been renamed to simply NSLocale.current
            self.inputPrice.text = formatter.string(from: price) // ex. "$123.44"
            
        } else {
            // insert alert controller because number is too large or invalid
            print("invalid price, try again!")
            self.present(self.priceAlertController, animated: true)
            inputPrice.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ inputPrice: UITextField) {
        print("text field began editing")
        inputPrice.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDescriptionSegue" {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backItem
            
            if self.negotiableSwitch.isOn {
                self.isNegotiable = true
            } else {
                self.isNegotiable = false
            }
            
            let dvc = segue.destination as! DescriptionViewController
            dvc.itemName = self.itemName
            dvc.coverPhoto = self.coverPhoto
            dvc.imageOne = self.imageOne
            dvc.imageTwo = self.imageTwo
            dvc.imageThree = self.imageThree
            dvc.imageFour = self.imageFour
            dvc.isNegotiable = self.isNegotiable
            dvc.itemPrice = self.itemPrice
        }
    }
}
