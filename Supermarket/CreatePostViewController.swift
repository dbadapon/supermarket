
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
import RAMAnimatedTabBarController
import SimpleAnimation

class CreatePostViewController: UIViewController, SupermarketObjectRecognizerDelegate {
    
    
    
    @IBOutlet weak var resultTag: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var resultShowing = false
    
    var startedNetworkRequests = false
    
    var toFetch: [String] = []
    
    var cachedResults: [String:Double] = [:]
    
    private var recognizer: SupermarketObjectRecognizer? {
        didSet {
            oldValue?.delegate = nil
            recognizer?.delegate = self
            
            if let recognizer = recognizer {
                previewLayer = AVCaptureVideoPreviewLayer(session: recognizer.session)
            } else {
                previewLayer = nil
            }
        }
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            oldValue?.removeFromSuperlayer()
            if let previewLayer = previewLayer {
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewView.layer.addSublayer(previewLayer)
            }
        }
    }

    var gradientLayer: CAGradientLayer!
    // for barcode recognition
    var qrCodeFrameView: UIView?
    // for object recognition
    var objectFrameView: UIView?
    // session
    var session: AVCaptureSession? {
        get {
            return self.recognizer?.session
        }
    }
    
    var objectRecognized = false
    
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
    @IBOutlet weak var resultView: UILabel!
    
    // flip and flash are placeholder buttons as of now
    // eventually add function
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    
    weak var delegate: CreatePostDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(true)
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
        
        objectFrameView = UIView()
        if let objectFrameView = objectFrameView {
            objectFrameView.layer.borderColor = UIColor.clear.cgColor
            objectFrameView.layer.borderWidth = 2
            view.addSubview(objectFrameView)
            view.bringSubview(toFront: objectFrameView)
        }

        guard let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            fatalError("No video camera available")
        }
        recognizer = SupermarketObjectRecognizer(passedDevice: camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recognizer = self.recognizer {
            recognizer.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let recognizer = self.recognizer {
            recognizer.session.stopRunning()
        }
    }
    
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
                self.session?.stopRunning()
                
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
                self.session?.stopRunning()
                
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
        previewLayer?.frame = self.previewView.bounds;
        gradientLayer?.frame = self.previewView.bounds;
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
        if self.objectRecognized {
            // if there's a high probability object being recognized
            // do not display constant results
            self.resultView.text = ""
        } else {
            // set the result view to whatever the classifications are
            // called on whenever classifications changes
            self.resultView.text = currentFrame.classifications
            // for debugging purposes
            // print("updating classifications")
        }
    }
    
    // this is called on when user captures image on screen
    func captureAndSegue(screenshot: UIImage) {
        self.imageToPass = screenshot
        performSegue(withIdentifier: "capturedSegue", sender: self)
    }
    
    func getBarcodeObject(barcodeObject: AVMetadataMachineReadableCodeObject) {
        // update the status label's text and set the bounds
        if let barCodeObject = self.previewLayer?.transformedMetadataObject(for: barcodeObject) {
            self.qrCodeFrameView?.frame = barCodeObject.bounds
        }
    }
    
    func barcodeObjectExists(doesExist: Bool) {
        // to make sure green box disappears when barcode not recognized
        if !doesExist {
            self.qrCodeFrameView?.frame = CGRect.zero
        }
    }
    
    func getRecognizedObject(recognizedObject: RecognizedObject) {

        if let convertedRect = self.previewLayer?.rectForMetadataOutputRect(ofInterest: recognizedObject.boundingBox) {
            self.objectFrameView?.frame = convertedRect
        }
        self.topMLResult = recognizedObject.highProbabilityMLResult
        delegate?.didFindNewObject(object: topMLResult)
        
        animateResultTag()
        
        resultLabel.text = recognizedObject.highProbabilityMLResult
        
        if !startedNetworkRequests {
            startedNetworkRequests = true
            runNetworkRequests()
        }
        
        getPrice(mlResult: recognizedObject.highProbabilityMLResult)
        showResultTag(recognizedObject: recognizedObject)
    }
    
    func highProbObjectRecognized(isRecognized: Bool) {
        // to make sure red box disappears when object is not recognized
        if !isRecognized {
            self.objectRecognized = false
            hideResultTag()
            self.objectFrameView?.frame = CGRect.zero
        } else {
            self.objectRecognized = true
            self.resultView.text = ""
        }
    }
    
    func runNetworkRequests() { // (while there's stuff in toFetch) run the request every 1 second to avoid hitting query limit
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchNext), userInfo: nil, repeats: true)
    }
    
    func getPrice(mlResult: String) { // trying the other beta... pls work omg i think it works
        // this is the one that keeps getting called!
        if let price = cachedResults[mlResult] {
            let formattedPrice = String(format: "%.2f", price)
            priceLabel.text = "$\(formattedPrice)"
        } else if !toFetch.contains(mlResult) {
            priceLabel.text = "checking price..."
            toFetch.append(mlResult)
        }
    }
    
    
    func fetchNext() { // fetch the next thing in the toFetch array
        
        if toFetch.count > 0 {
            let query = toFetch[0]
            var price = -100.0
            let baseURL = "http://api.walmartlabs.com/v1/search?query="
            let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
            
            let newString = query.replacingOccurrences(of: " ", with: "+")
//            newString = newString.replacingOccurrences(of: ",", with: "")

            let wholeUrl = baseURL + newString + endUrl
            
            request(wholeUrl, method: .get).validate().responseJSON { (response) in
                if response.result.isSuccess,
                    let responseDictionary = response.result.value as? [String: Any] {
                    let numberOfItems = responseDictionary["numItems"] as! Int
                    if numberOfItems > 0 {
                        let itemArray = responseDictionary["items"] as! [[String: Any]]
                        
                        let items = itemArray[0]
                        if let checkPrice = items["salePrice"] {
                            price = checkPrice as! Double
                            self.cachedResults[query] = price
                            // only set the price label if the result label is still the same one...
                            if self.resultLabel.text == query {
                                let formattedPrice = String(format: "%.2f", price)
                                self.priceLabel.text = "$\(formattedPrice)"
                            }
                            
                        } else {
                            self.priceLabel.text = "checking price..."
                        }
                        
                    }
                } else {
                    self.priceLabel.text = "price unavailable"
                    // print ("it's not getting a response")
                    print (response.result.error!)
                }
                
            }
            
         toFetch.remove(at: 0)
        }
    }
    
    func animateResultTag() {
        let center_x = (self.objectFrameView?.frame.origin.x)! + ((self.objectFrameView?.frame.width)!/2)
        UIView.animate(withDuration: 0.5, animations: {
            self.resultTag.frame.origin.x = center_x - (self.resultTag.bounds.width/2)
            self.resultTag.frame.origin.y = (self.objectFrameView?.frame.origin.y)! - self.resultTag.bounds.height - 12
        })
    }
    
    func showResultTag(recognizedObject: RecognizedObject) {
        // if it's already there, keep it there and don't do anything
        // if it's not there, fade it in
        
        if !resultShowing {
            
            resultTag.isHidden = true
            view.addSubview(resultTag)
            view.bringSubview(toFront: resultTag)
            
            resultTag.fadeIn(duration: 0.5, delay: 0, completion: { (complete) in
                self.resultShowing = true
            })
            
            resultTag.isHidden = false
        }
    }
    
    func hideResultTag() {
        // if it's there, keep it for a while, and fade it
        // if the resultLabel is still the same, we want the thing to stay on screen and just move with the box...
        // otherwise get rid of it
        if resultShowing {
            resultTag.fadeOut(duration: 0.5, delay: 2, completion: { (complete) in
                    self.resultShowing = false
                })
        }
    }
    
    @IBAction func captureAction(_ sender: UIButton) {
        if let recognizer = self.recognizer {
            recognizer.captureScreenshot()
            self.topMLResult = recognizer.topMLResult
        }
    }
    
    @IBAction func toARKitAction(_ sender: UIButton) {
        // segue to ARKit Scene
        performSegue(withIdentifier: "toARKitSegue", sender: self)
    }
    
    private func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(captureAction(_:)), for: .touchUpInside)
        
        // MAKE THIS THE GO TO 3D BUTTON
        // HELLUR HELLUR WORK ON THIS
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(toARKitAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        // flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "capturedSegue" {
            let dvc = segue.destination as? PhotoViewController
            dvc?.backgroundImage = self.imageToPass
            dvc?.topMLResult = self.topMLResult
            return
        }
        
        // only happens when barcode recognized and user clicks scan
        if segue.identifier == "barcodeToPreviewSegue" {
            let dvc = segue.destination as! UINavigationController
            let vc = dvc.topViewController as! PreviewViewController
            vc.nameString = self.nameString
            vc.priceString = self.priceString
            vc.pictureUrl = self.pictureUrl
        }
    }
}
