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

class PreviewViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {

    // to be able to add and change images selected
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var imageViewFour: UIImageView!
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    let nameAlertController = UIAlertController(title: "Max Characters Reached", message: "Item name CANNOT exceed 50 characters", preferredStyle: .alert)
    
    @IBAction func cancelAction(_ sender: UIButton) {
        // nameString == "" means not from barcode
        // so dismissing it takes user back to PhotoVC
        if (nameString == "") {
            dismiss(animated: false, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toPriceSegue", sender: self)
    }
    
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
        
        // make tap gestures to be able to add pictures
        let UITapRecognizerCover = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageCover(_sender:)))
        UITapRecognizerCover.delegate = self
        self.coverPhoto.addGestureRecognizer(UITapRecognizerCover)
        self.coverPhoto.isUserInteractionEnabled = true
        
        let UITapRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageOne(_sender:)))
        UITapRecognizerOne.delegate = self
        self.imageViewOne.addGestureRecognizer(UITapRecognizerOne)
        self.imageViewOne.isUserInteractionEnabled = true
        
        let UITapRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageTwo(_sender:)))
        UITapRecognizerTwo.delegate = self
        self.imageViewTwo.addGestureRecognizer(UITapRecognizerTwo)
        self.imageViewTwo.isUserInteractionEnabled = true
        
        let UITapRecognizerThree = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageThree(_sender:)))
        UITapRecognizerThree.delegate = self
        self.imageViewThree.addGestureRecognizer(UITapRecognizerThree)
        self.imageViewThree.isUserInteractionEnabled = true
        
        let UITapRecognizerFour = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageFour(_sender:)))
        UITapRecognizerFour.delegate = self
        self.imageViewFour.addGestureRecognizer(UITapRecognizerFour)
        self.imageViewFour.isUserInteractionEnabled = true
        
        print(pictureUrl)
        
        itemName.delegate = self
        
        // tap gesture recognizer to dismiss keyboard
        // looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PreviewViewController.dismissKeyboard))
        
        // uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
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
        let borderColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha:1.0)
        
        itemName.layer.borderColor = borderColor.cgColor;
        itemName.layer.borderWidth = 0.5;
        itemName.layer.cornerRadius = 5.0;
        
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
    
    func tappedImageCover(_sender: AnyObject) {
        print("Cover image tapped!")
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            (action) in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: alert)
            popover!.present(from: view.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    func tappedImageOne(_sender: AnyObject) {
        print("Image one tapped!")
    }
    
    func tappedImageTwo(_sender: AnyObject) {
        print("Image two tapped!")
    }
    
    func tappedImageThree(_sender: AnyObject) {
        print("Image three tapped!")
    }
    
    func tappedImageFour(_sender: AnyObject) {
        print("Image four tapped!")
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            openLibrary()
        }
    }
    
    func openLibrary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.present(from: view.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    // delegate methods
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismiss(animated: true, completion: nil)
        // imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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

