
//
//  CreatePostViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/21/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import Alamofire

class CreatePostViewController: UIViewController, SupermarketObjectRecognizerDelegate {
    
    var recognizer: SupermarketObjectRecognizer?
    
    // preview layer
    var previewLayer: AVCaptureVideoPreviewLayer!
    // overlay layer
    var gradientLayer: CAGradientLayer!
    // for barcode recognition
    var qrCodeFrameView: UIView?
    
    // image to pass onto next view controller
    // to "freeze" screen when user clicks capture button
    var imageToPass: UIImage!
    // string to pass onto next view controller
    // to run searches on when user captures a picture
    var topMLResult = ""
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var resultView: UILabel!
    
    // flip and flash are placeholder buttons as of now
    // eventually add function
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        // add swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        // add flash, flip-camera, and capture buttons to view
        addButtons()
        
        // get hold of the default video camera
        guard let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            fatalError("No video camera available")
        }
        
        recognizer = SupermarketObjectRecognizer(passedDevice: camera)
        
        // add the preview layer
        // also configure live preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: recognizer!.session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(previewLayer)
        
        // add a slight gradient overlay so we can read the results easily
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor,
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.3]
        self.previewView.layer.addSublayer(gradientLayer)
        
        // Initialize QR Code Frame to highlight the QR code
        // qrCodeFrameView variable is invisible on screen because
        // the size of the UIView object is set to zero by default
        // when a QR code is detected, change its size and turn it into a green box
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    } // end of viewDidLoad
    
    // for swipe gestures
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("swiped right")
                
                // self.previewLayer.removeFromSuperlayer()
                // self.previewLayer = nil
                // self.session.stopRunning()
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                UIView.performWithoutAnimation {
                    self.show(vc, sender: self)
                    vc.selectedIndex = 1
                }
                
            case UISwipeGestureRecognizerDirection.down:
                print("swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("swiped left")
                
                // self.previewLayer.removeFromSuperlayer()
                // self.previewLayer = nil
                // self.session.stopRunning()
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                UIView.performWithoutAnimation {
                    self.show(vc, sender: self)
                    vc.selectedIndex = 3
                }
                
            case UISwipeGestureRecognizerDirection.up:
                print("swiped up")
            default:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = self.previewView.bounds;
        gradientLayer.frame = self.previewView.bounds;
    }
    
    // delegate methods
    func updateRecognizedObject(recognizedObject: RecognizedObject) {
        
    }
    func updateRecognizedBarcode(recognizedBarcode: RecognizedBarcode) {
        
    }
    func updateCurrentFrame(currentFrame: CurrentFrame) {
        // set the result view to whatever the classifications are
        self.resultView.text = currentFrame.classifications
        print("updating classifications")
    }
//    func captureScreenshot(screenshot: UIImage) {
//        self.imageToPass = screenshot
//    }
    
    
    @IBAction func captureAction(_ sender: UIButton) {
        if recognizer != nil {
            self.imageToPass = recognizer!.captureScreenshot()
            self.topMLResult = recognizer!.topMLResult
            print(self.imageToPass)
            // infinite loop LOLOL, NOT THE SOLUTION
//            let blankSize = CGSize(width: 0, height: 0)
//            while imageToPass.size == blankSize {
//                // do nothing just wait
//                // because recognizer needs time to capture screenshot
//            }
            performSegue(withIdentifier: "capturedSegue", sender: self)
        }
    }
    
    private func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(captureAction(_:)), for: .touchUpInside)
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        // flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        // flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "capturedSegue" {
            // uncomment out to stop running AVCaptureSession
            // self.previewLayer.removeFromSuperlayer()
            // self.previewLayer = nil
            // self.session.stopRunning()
            
            let dvc = segue.destination as! PhotoViewController
            dvc.backgroundImage = imageToPass
            dvc.topMLResult = topMLResult
            print("PRINTING STUFF")
            print(dvc.backgroundImage)
            print(dvc.topMLResult)
        }
        
        // only happens when barcode recognized and user clicks scan
        if segue.identifier == "barcodeToPreviewSegue" {
            // uncomment out to stop running AVCaptureSession
            // self.previewLayer.removeFromSuperlayer()
            // self.previewLayer = nil
            // self.session.stopRunning()
            
            let dvc = segue.destination as! PreviewViewController
            // dvc.nameString = self.nameString
            // dvc.priceString = self.priceString
            // dvc.pictureUrl = self.pictureUrl
            // for debugging purposes
            // print(self.pictureUrl)
        }
    }
}


