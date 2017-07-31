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
import IQKeyboardManagerSwift

class PreviewViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextFieldDelegate {

    // color to use for app
    let textColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha:1.0)
    
    let lightGray = UIColor(colorLiteralRed: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 0.50).cgColor
    
    // Next button
    @IBOutlet weak var nextButton: UIButton!
    
    
    // alter controllers
    let nextAlertController = UIAlertController(title: "Invalid Action", message: "Cover photo is required", preferredStyle: .alert)
    let nameRequiredAlertController = UIAlertController(title: "Name Required", message: "Please enter an item name to continue", preferredStyle: .alert)
    let cameraSelectAlertController = UIAlertController(title: "Camera NOT available", message: "Please select Photo Library", preferredStyle: .alert)
    let nameAlertController = UIAlertController(title: "Max Characters Reached", message: "Item name CANNOT exceed 50 characters", preferredStyle: .alert)
    
    let vc = UIImagePickerController()

    // to be able to add and change images selected
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var imageViewFour: UIImageView!
    
    // to be able to assign user picked image to correct image view
    // 0 is cover photo, 1 - 4 would be for images 1 - 4
    var selectedImage = -1
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if (nameString == "") {
            dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func cancelAction(_ sender: UIButton) {
        // nameString == "" means not from barcode
        // so dismissing it takes user back to PhotoVC
        if (nameString == "") {
            dismiss(animated: false, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var itemName: UITextField!
    
    
    @IBOutlet weak var charCountLabel: UILabel!
    
     // RETURN KEY
    var returnKey: IQKeyboardReturnKeyHandler?
    
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
        
        // Configure keyboard
        
        self.returnKey = IQKeyboardReturnKeyHandler.init(controller: self)
        
//        itemName.delegate = self
//        IQKeyboardManager.sharedManager().enable = true

        
//        returnKey.textFieldShouldEndEditing(itemName)
        
    
//        returnKey.textFieldShouldEndEditing(itemName)
        
        
        // Style navigation bar
        
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // make navbar translucent (remove bottom line)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Style Next button
        nextButton.layer.cornerRadius = 5

        
        // set color of alert controllers
        nextAlertController.view.tintColor = textColor
        cameraSelectAlertController.view.tintColor = textColor
        
        let UITapRecognizerCover = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageCover(_sender:)))
        UITapRecognizerCover.delegate = self
        self.coverPhoto.addGestureRecognizer(UITapRecognizerCover)
        self.coverPhoto.isUserInteractionEnabled = true
        
        // make tap gestures to be able to add pictures
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

        
//        itemName.delegate = self
        
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
        let borderColor = lightGray
        
        itemName.layer.borderColor = borderColor
        itemName.layer.borderWidth = 0.5;
        itemName.layer.cornerRadius = 5.0;
        
        // for image picker
        vc.delegate = self
        vc.allowsEditing = true
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        
        // add the OK action to the alert controllers
        cameraSelectAlertController.addAction(OKAction)
        nextAlertController.addAction(OKAction)
        nameAlertController.addAction(OKAction)
        nameRequiredAlertController.addAction(OKAction)
        
        /*
        // code for keyboard to make screen scroll the old method
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        */
    }
    

    
    func tappedImageCover(_sender: AnyObject) {
        print("Cover image tapped!")
        self.selectedImage = 0
        self.showOptions()
    }
    
    func tappedImageOne(_sender: AnyObject) {
        print("Image one tapped!")
        self.selectedImage = 1
        self.showOptions()
    }
    
    func tappedImageTwo(_sender: AnyObject) {
        print("Image two tapped!")
        self.selectedImage = 2
        self.showOptions()
    }
    
    func tappedImageThree(_sender: AnyObject) {
        print("Image three tapped!")
        self.selectedImage = 3
        self.showOptions()
    }
    
    func tappedImageFour(_sender: AnyObject) {
        print("Image four tapped!")
        self.selectedImage = 4
        self.showOptions()
    }
    
    func showOptions() {
        let alert:UIAlertController = UIAlertController(title: "Image Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = textColor
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) {
            (action) in
            if self.selectedImage == 0 {
                // not a possible option now
                // because user cannot change cover photo
                self.coverPhoto.image = #imageLiteral(resourceName: "cameraMask.png")
            } else if self.selectedImage == 1 {
                self.imageViewOne.image = #imageLiteral(resourceName: "cameraMask.png")
            } else if self.selectedImage == 2 {
                self.imageViewTwo.image = #imageLiteral(resourceName: "cameraMask.png")
            } else if self.selectedImage == 3 {
                self.imageViewThree.image = #imageLiteral(resourceName: "cameraMask.png")
            } else if self.selectedImage == 4 {
                self.imageViewFour.image = #imageLiteral(resourceName: "cameraMask.png")
            } else {
                print("Something went wrong in showOptions")
            }
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            (action) in
            self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) {
            (action) in
            self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            (action) in
        }
        
        // Add the actions
        // originally in code, but not necessary because now it's in viewDidLoad
        // picker?.delegate = self
        alert.addAction(deleteAction)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            popover = UIPopoverController(contentViewController: alert)
            popover!.present(from: view.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        } else {
            self.present(self.cameraSelectAlertController, animated: true)
        }
    }
    
    func openLibrary() {
        print("Using photo library")
        vc.sourceType = .photoLibrary
        self.present(vc, animated: true, completion: nil)
    }
    
    // delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the image captured by the UIImagePickerController
        // Do something with the images (based on your use case)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("edited")
            if self.selectedImage == 0 {
                coverPhoto.image = image
            } else if self.selectedImage == 1 {
                imageViewOne.image = image
            } else if self.selectedImage == 2 {
                imageViewTwo.image = image
            } else if self.selectedImage == 3 {
                imageViewThree.image = image
            } else if self.selectedImage == 4 {
                imageViewFour.image = image
            } else {
                print("Something went wrong in imagePickerController")
            }
            //imageToPost.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("original")
            if self.selectedImage == 0 {
                coverPhoto.image = image
            } else if self.selectedImage == 1 {
                imageViewOne.image = image
            } else if self.selectedImage == 2 {
                imageViewTwo.image = image
            } else if self.selectedImage == 3 {
                imageViewThree.image = image
            } else if self.selectedImage == 4 {
                imageViewFour.image = image
            } else {
                print("Something went wrong in imagePickerController")
            }
        } else{
            print("Something went wrong in imagePickerController")
        }
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancel")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func keyboardWillShow(notification: NSNotification) {
        // self.view.endEditing(false)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            // shifts screen up as keyboard appears
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // self.view.endEditing(true)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            // shifts screen down as keyboard disappears
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    */
    
    /*
    func textViewDidChange(_ itemName: UITextView) {
        let text = itemName.text!
        let remainingCount = 50 - text.characters.count
        let count = text.characters.count
        
        if count == 49 {
            charCountLabel.text = "Item Name (1 character remaining)"
        } else if count <= 50 {
            charCountLabel.text = "Item Name (" + String(remainingCount) + " characters remaining)"
        } else {
            charCountLabel.text = "Item Name (0 characters remaining)"
            self.present(self.nameAlertController, animated: true)
        }
    }
 */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toPriceSegue" {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backItem
            
            let dvc = segue.destination as! PriceViewController
            dvc.itemName = self.itemName.text!
            dvc.coverPhoto = self.coverPhoto
            dvc.imageOne = self.imageViewOne
            dvc.imageTwo = self.imageViewTwo
            dvc.imageThree = self.imageViewThree
            dvc.imageFour = self.imageViewFour
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print("Tapped next...")
        if itemName == nil || itemName.text == "" {
            self.present(self.nameRequiredAlertController, animated: true)
            return false
        } else if coverPhoto.image == #imageLiteral(resourceName: "cameraMask.png") {
            self.present(self.nextAlertController, animated: true)
            return false
        }
        return true
    }
}

