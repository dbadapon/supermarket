//
//  NewPostViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import CameraManager
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cameraManager = CameraManager()
    let vc = UIImagePickerController()
    var image: UIImage! {
        didSet {
            print("hey")
        }
    }
    
    @IBOutlet weak var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print ("view did load is running")
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        
        
        // Setting up camera/photo library
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraManager.addPreviewLayerToView(self.cameraView)
            cameraManager.shouldEnableTapToFocus = true
            cameraManager.shouldEnablePinchToZoom = true
            cameraManager.cameraOutputQuality = .high
            cameraManager.cameraOutputMode = .stillImage
            cameraManager.flashMode = .auto
        }
        
//        let username = "hello"
//        let password = "password"
//        
//        if username.isEmpty || password.isEmpty {
//            print ("You cannot have empty username/password")
//        } else {
//            PFUser.logInWithUsername(inBackground: username, password: password, block: { (user: PFUser?, error: Error?) in
//                if let error = error {
//                    print ("there was an error with logging in")
//                    let errorInfo = error._userInfo as! [String: Any]
//                    let code = errorInfo["code"] as! Int
//                    if code == 101 {
//                        print ("invalid login credentials")
//                    }
//                    
//                } else {
//                    print("User logged in successfully")
//                    // display view controller that needs to shown after successful login
//                    var categories: [String: [Post]?]? = [:]
//                    categories = ["Math": nil, "Science": nil, "English": nil, "History": nil]
//                    
//                    Market.postMarket(withName: "Rice Students", withCategories: categories, withNewCategory: true, withPublic: true) { (success, error: Error?) in
//                        if success {
//                            print ("Rice Market posted")
//                        } else {
//                            print (error?.localizedDescription)
//                        }
//                    }
//                    
//                    Market.postMarket(withName: "Yale Students", withCategories: categories, withNewCategory: true, withPublic: true) { (success, error: Error?) in
//                        if success {
//                            print ("Yale Market posted")
//                        } else {
//                            print (error?.localizedDescription)
//                        }
//                    }
//                    
//                    Market.postMarket(withName: "UC Irvine Students", withCategories: categories, withNewCategory: true, withPublic: true) { (success, error: Error?) in
//                        if success {
//                            print ("UC Irvine Market posted")
//                        } else {
//                            print (error?.localizedDescription)
//                        }
//                    }
//                    
//
//
//                }
//            })
//        }
//        let destinations = ["Rice Students": ["English", "Math"], "Yale Students": ["History", "Science"], "UC Irvine Students": ["English"]]
//        Market.postToMarkets(destinations: destinations, post: "Making sure it goes to the markets!!!")
        
        

        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.image != nil {
            print ("WOAH THERE'S A PICTURE")
        } else if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print ("THE IMAGE IS: \(self.image)\n")
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        print ("it gets to image picture controller")
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.image = editedImage
        

        // Dismiss UIImagePickerController to go back to your original view controller

        dismiss(animated: true) { 
            self.performSegue(withIdentifier: "confirmPhotoSegue", sender: self)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ vc: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        tabBarController!.selectedIndex = 0
    }
    

    @IBAction func onCapture(_ sender: Any) {
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
            if let error = error {
                print (error.localizedDescription)
            } else {
                self.image = image
                self.performSegue(withIdentifier: "confirmPhotoSegue", sender: self)
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "confirmPhotoSegue" {
            let destination = segue.destination as! ConfirmPhotoViewController
            destination.image = self.image
            self.image = nil
        }
        
        
    }
}
