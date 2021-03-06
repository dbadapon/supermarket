
//
//  ARCreateViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/21/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import Alamofire
import RAMAnimatedTabBarController
import ARKit
import SceneKit
import ModelIO
import SceneKit.ModelIO


class ARCreateViewController: UIViewController, SupermarketObjectRecognizerDelegate {
    
    
    
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var recognizer: SupermarketObjectRecognizer?
    
    // preview layer
    var previewLayer: AVCaptureVideoPreviewLayer!
    // overlay layer
    var gradientLayer: CAGradientLayer!
    // for barcode recognition
    var qrCodeFrameView: UIView?
    // for object recognition
    var objectFrameView: UIView?
    
    // image to pass onto next view controller
    // to "freeze" screen when user clicks capture button
    var imageToPass: UIImage!
    // string to pass onto next view controller
    // to run searches on when user captures a picture
    var topMLResult = ""
    
    // to pass onto next view controller
    // when barcode is recognized
    var nameString = ""
    var priceString = ""
    var pictureUrl = ""
    
    @IBOutlet weak var previewView: UIView!
    
    // flip and flash are placeholder buttons as of now
    // eventually add function
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    
    weak var delegate: CreatePostDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide tab bar
//        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
//        animatedTabBar.animationTabBarHidden(true)
        
        print ("done hiding tab bar")
        
        // get hold of the default video camera
        guard let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            fatalError("No video camera available")
        }
        
        recognizer = SupermarketObjectRecognizer(passedDevice: camera)
        recognizer?.delegate = self
        
        // add the preview layer
        // also configure live preview layer
        // previewLayer = AVCaptureVideoPreviewLayer(session: recognizer!.session)
        // previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        // previewView.layer.addSublayer(previewLayer)
        
        // add a slight gradient overlay so we can read the results easily
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor,
            UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.3]
        self.previewView.layer.addSublayer(gradientLayer)
        
        
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
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal

        // runs view session
        // basic AR tracking
        sceneView.session.run(configuration)
        print ("just ran the scene view session")
        
        
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
        
        // do same for object frame
        // object frame only appears when high threshold of ML is surpassed
        objectFrameView = UIView()
        
        if let objectFrameView = objectFrameView {
            objectFrameView.layer.borderColor = UIColor.red.cgColor
            objectFrameView.layer.borderWidth = 2
            view.addSubview(objectFrameView)
            view.bringSubview(toFront: objectFrameView)
        }
    } // end of viewDidLoad
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
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
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! RAMAnimatedTabBarController
                UIView.performWithoutAnimation {
                    self.show(vc, sender: self)
                    vc.setSelectIndex(from: 0, to: 1)
                }
                
            case UISwipeGestureRecognizerDirection.down:
                print("swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("swiped left")
                
                // self.previewLayer.removeFromSuperlayer()
                // self.previewLayer = nil
                // self.session.stopRunning()
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! RAMAnimatedTabBarController
                UIView.performWithoutAnimation {
                    self.show(vc, sender: self)
                    vc.setSelectIndex(from: 0, to: 3)
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
        // previewLayer.frame = self.previewView.bounds;
        gradientLayer.frame = self.previewView.bounds;
    }
    
    // delegate methods
    func updateRecognizedBarcode(recognizedBarcode: RecognizedBarcode) {
        self.nameString = recognizedBarcode.nameString
        self.priceString = recognizedBarcode.priceString
        self.pictureUrl = recognizedBarcode.pictureUrl
        // barcode has been recognized
        // no of those fields should be empty strings
        // so perform segue
        if self.nameString != "" && self.priceString != "" && self.pictureUrl != "" {
            performSegue(withIdentifier: "barcodeToPreviewSegue", sender: self)
        }
    }
    
    func updateCurrentFrame(currentFrame: CurrentFrame) {
        // set the result view to whatever the classifications are
        // called on whenever classifications changes
        
        // self.resultView.text = currentFrame.classifications
        
        // for debugging purposes
        // print("updating classifications")
    }
    
    // this is called on when user captures image on screen
    func captureAndSegue(screenshot: UIImage) {
        self.imageToPass = screenshot
        performSegue(withIdentifier: "capturedSegue", sender: self)
    }
    
    func getBarcodeObject(barcodeObject: AVMetadataMachineReadableCodeObject) {
        // update the status label's text and set the bounds
        let barCodeObject = self.previewLayer.transformedMetadataObject(for: barcodeObject)
        self.qrCodeFrameView?.frame = barCodeObject!.bounds
    }
    
    func barcodeObjectExists(doesExist: Bool) {
        // to make sure green box disappears when barcode not recognized
        if !doesExist {
            self.qrCodeFrameView?.frame = CGRect.zero
        }
    }
    
    func getRecognizedObject(recognizedObject: RecognizedObject) {
        print("GET RECOGNIZED OBJECT, MEANS HIGH PROBS HAS BEEN REACHED YEEE")
        // update and set the bounds of the high probability object
        
        // let convertedRect = self.previewLayer.rectForMetadataOutputRect(ofInterest: recognizedObject.boundingBox)
        // print(convertedRect)
        // move the highlighted box
        print("SET RECTANGLE")
        // self.objectFrameView?.frame = convertedRect
        self.topMLResult = recognizedObject.highProbabilityMLResult
        self.didFindNewObject(object: self.topMLResult)
        // delegate?.didFindNewObject(object: topMLResult)
        // print ("just tried to call the delegate method")
        
        // THIS IS THE PLACE TO MAKE THE POPUP BOX APPEAR
        // use the string below
        // recognizedObject.highProbMLResult (ex. "soda can")
        // recognizedObject.highProbClassifications --- (no need to use this "soda can 0.95")
        
        // resultLabel.text = recognizedObject.highProbabilityMLResult
        
//        view.addSubview(resultTag)
//        view.bringSubview(toFront: resultTag)
        
        // resultTag.isHidden = false
        //        if let resultTag = self.resultTag {
        //            view.addSubview(resultTag)
        //            view.bringSubview(toFront: resultTag)
        //        }
        
        
    }
    
    func didFindNewObject(object: String) {
        print ("okay it got to did find new object")
        let text = SCNText(string: self.topMLResult, extrusionDepth: 0.01)
        text.firstMaterial?.diffuse.contents = UIColor.white
        // text.firstMaterial?.specular.contents = UIColor.orange
        text.font = UIFont(name: "Optima", size: 0.04)
        
        // SceneKit uses line segments to approximate the curved shapes of text
        // characters when converting text into a three-dimensional geometry
        // higher flatness values result in fewer segments, reducing the
        // smoothness of curves and improving rendering performance
        // default value of this property is 0.6
        text.flatness = 1.0
        
        // text.containerFrame is a rectangle specifying the area in which SceneKit should lay out the text
        // text.containerFrame = CGRect(x: 0, y: 0, width: 30, height: 20)
        
        let textNode = SCNNode(geometry: text)
        // textNode.position = SCNVector3(-0.2 + x, -0.9 + delta, -1)
        //
        //        x += 0.12
        //
        let cc = getCameraCoordinates(sceneView: sceneView)
        print(cc)
        
        // place text where camera is
        // textNode.position = SCNVector3(cc.x, cc.y, cc.z)
        // place text 0.2m in front of camer and 0.2m below camera
        textNode.position = SCNVector3(cc.x, cc.y - 1.0, cc.z - 0.2)
        // textNode.position = SCNVector3(0.0, 0.0, 0.0)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    func highProbObjectRecognized(isRecognized: Bool) {
        // to make sure red box disappears when object is not recognized
        if !isRecognized {
            self.objectFrameView?.frame = CGRect.zero
            
            // resultTag.isHidden = true
            
            // THIS IS THE PLACE TO MAKE THE POPUP BOX DISAPPEAR
            //            if let resultTag = self.resultTag {
            //                resultTag.removeFromSuperview()
            //            }
            
            
        } else {
            // put red box in middle of screen
            // self.objectFrameView?.frame = CGRect(x: view.frame.midX, y: view.frame.midY, width: 120.0, height: 120.0)
        }
    }
    
    
    @IBAction func captureAction(_ sender: UIButton) {
        if recognizer != nil {
            recognizer!.captureScreenshot()
            self.topMLResult = recognizer!.topMLResult
        }
    }
    
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    
    func getCameraCoordinates(sceneView: ARSCNView) -> myCameraCoordinates {
        let session = sceneView.session
        let currentFrame = session.currentFrame
        let camera = currentFrame?.camera
        let transform = camera?.transform
        // let cameraTransform = sceneView.session.currentFrame?.camera.transform
        
        let cameraCoordinates = MDLTransform(matrix: transform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
    
    
    private func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(captureAction(_:)), for: .touchUpInside)
        
        // MAKE THIS THE GO TO 3D BUTTON
        // HELLUR HELLUR WORK ON THIS
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        // flipCameraButton.addTarget(self, action: #selector(toARKitAction(_:)), for: .touchUpInside)
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
            
            let dvc = segue.destination as! UINavigationController
            let vc = dvc.topViewController as! PreviewViewController
            vc.nameString = self.nameString
            vc.priceString = self.priceString
            vc.pictureUrl = self.pictureUrl
            // for debugging purposes
            // print(self.pictureUrl)
        }
        
        if segue.identifier == "toARKitSegue" {
            let destination = segue.destination as! ARKitViewController
            self.delegate = destination
        }
    }
}

