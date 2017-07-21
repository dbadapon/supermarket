//
//  PreviewViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/21/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

//
//  PreviewViewController.swift
//  VisionSample
//
//  Created by Xiuya Yao on 7/19/17.
//  Copyright © 2017 MRM Brand Ltd. All rights reserved.
//

import UIKit
// import Alamofire
// import AlamofireImage

class PreviewViewController: UIViewController, UITextViewDelegate {
    
    let nameAlertController = UIAlertController(title: "Max Characters Reached", message: "Item name CANNOT exceed 140 characters", preferredStyle: .alert)

    
    @IBOutlet weak var itemName: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    // from barcode reader
    var nameString = ""
    var priceString = ""
    var pictureUrl = ""
    // var barcodeRetrievedImage: UIImage!
    
    // from photo vc --> using user captured image
    var backgroundImage: UIImage!
    var topMLResult: String!
    
    @IBOutlet weak var coverPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(pictureUrl)
        
        itemName.delegate = self
        
        // exactly two possibilites: image from photo vc or from barcode
        
        // if image was passed from photo vc
        if backgroundImage != nil {
            coverPhoto.image = backgroundImage
        }
        
        // if image was retrieved from barcode
        if pictureUrl != "" {
            let request: URLRequest = URLRequest(url: URL(string: pictureUrl)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response: URLResponse!,data: Data!,error: Error!) -> Void in
                if error == nil {
                    self.coverPhoto.image = UIImage(data: data)
                } else {
                    print("error loading image from barcode")
                }
            })
        }
        
        // border around textbox for user to type item name
        /*
        let borderColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha:1.0)
        
        itemName.layer.borderColor = borderColor.cgColor;
        itemName.layer.borderWidth = 1.0;
        itemName.layer.cornerRadius = 5.0;
         */
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        
        // add the OK action to the alert controller
        nameAlertController.addAction(OKAction)
        
        // code for keyboard to make screen scroll up
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textViewDidChange(_ itemName: UITextView) {
        let text = itemName.text!
        let remainingCount = 50 - text.characters.count
        let count = text.characters.count
        
        if count == 49
        {
            charCountLabel.text = "Item Name: (1 character remaining)"
        } else if count <= 50 {
            charCountLabel.text = "Item Name: (" + String(remainingCount) + " characters remaining)"
        } else {
            charCountLabel.text = "Item Name: (0 characters remaining)"
            self.present(self.nameAlertController, animated: true)
        }
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

