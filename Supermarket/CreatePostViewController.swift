
//
//  CreatePostViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/21/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Vision
import Alamofire
import AVFoundation

class CreatePostViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    // for barcode scanner
    // private var scanner: MSCodeScanner!
    var qrCodeFrameView: UIView?
    var codeString = ""
    var nameString = ""
    var priceString = ""
    // var lastQuery: String?
    var pictureUrl = ""
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    // video capture session
    var session = AVCaptureSession()
    // preview layer
    var previewLayer: AVCaptureVideoPreviewLayer!
    // queue for processing video frames
    var captureQueue = DispatchQueue(label: "captureQueue")
    // overlay layer
    var gradientLayer: CAGradientLayer!
    // vision request
    var visionRequests = [VNRequest]()
    
    // added code to capture image
    let stillImageOutput = AVCaptureStillImageOutput()
    // image to pass onto next view controller
    // to "freeze" screen when user clicks capture button
    var imageToPass: UIImage!
    // string to pass onto next view controller
    // to run searches on when user captures a picture
    var topMLResult = ""
    
    var recognitionThreshold : Float = 0.19
    
    // @IBOutlet weak var thresholdStackView: UIStackView!
    // @IBOutlet weak var threshholdLabel: UILabel!
    // @IBOutlet weak var threshholdSlider: UISlider!
    
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
        
        // slider for adjusting threshold is hidden
        // self.thresholdStackView.isHidden = true
        addButtons()
        
        // get hold of the default video camera
        guard let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            fatalError("No video camera available")
        }
        do {
            // add the preview layer
            // also configure live preview layer
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
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
            
            // create the capture input and the video output
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            session.sessionPreset = AVCaptureSessionPresetHigh
            
            // wire up the session
            session.addInput(cameraInput)
            session.addOutput(videoOutput)
            
            // ADDED CODE
            // Add photo output.
            // let stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
            
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
                print("session can accept stillImageOutput")
                // ...
                // Configure the Live Preview here...
            } else {
                print("session cannot accept stillImageOutput")
            }
            
            
            // beginning of code for barcode and QR code scanning
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            session.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
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
            // end of code for barcode and QR code scanning
            
            
            // make sure we are in portrait mode
            let conn = videoOutput.connection(withMediaType: AVMediaTypeVideo)
            conn?.videoOrientation = .portrait
            
            // Start the session
            session.startRunning()
            
            // set up the vision model
            guard let resNet50Model = try? VNCoreMLModel(for: Resnet50().model) else {
                fatalError("Could not load model")
            }

            // set up the request using our vision model
            let classificationRequest = VNCoreMLRequest(model: resNet50Model, completionHandler: handleClassifications)
            classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
            // dom: it won't build if I use the stuff below...
//                VNImageCropAndScaleOption.centerCrop
//                = VNImageCropAndScaleOption.centerCrop
            visionRequests = [classificationRequest]
            
        } catch {
            fatalError(error.localizedDescription)
        }
        // updateThreshholdLabel()
    }
    
    /*
     func updateThreshholdLabel () {
     self.threshholdLabel.text = "Threshold: " + String(format: "%.2f", recognitionThreshold)
     
     }
     */
    
    // for swipe gestures
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                
                self.previewLayer.removeFromSuperlayer()
                // self.previewLayer = nil
                self.session.stopRunning()

                let storyboard: UIStoryboard = UIStoryboard(name: "SellFeed", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SellFeedController") as! UINavigationController
                UIView.performWithoutAnimation {
                    self.show(vc, sender: self)
                }
                
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                
                self.previewLayer.removeFromSuperlayer()
                // self.previewLayer = nil
                self.session.stopRunning()
                
                let storyboard: UIStoryboard = UIStoryboard(name: "NotificationStoryboard", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "NotificationController") as! UINavigationController
                UIView.performWithoutAnimation {
                    self.show(vc, sender: self)
                }

            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
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
                    self.pictureUrl = imageUrl
                    print ("THIS IS THE IMAGE URL: \(imageUrl)")
                    
                    self.nameString = String(describing: item["name"]!)
                    self.priceString = "$" + String(describing: item["salePrice"]!)
                    print (item["salePrice"]!)
                    
                    self.performSegue(withIdentifier: "barcodeToPreviewSegue", sender: self)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = self.previewView.bounds;
        gradientLayer.frame = self.previewView.bounds;
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        connection.videoOrientation = .portrait
        var requestOptions:[VNImageOption: Any] = [:]
        
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics: cameraIntrinsicData]
        }
        
        // for orientation see kCGImagePropertyOrientation
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 1)!, options: requestOptions)
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // for debugging purposes
        print("CAPTURED BARCODE")
        
        // Check that metadataObjects array contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        // update the status label's text and set the bounds
        let barCodeObject = previewLayer.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        
        if metadataObj.stringValue != nil {
            codeString = metadataObj.stringValue!
        }
        
        // make query if barcode is read
        if codeString != "" {
            checkPriceWithName(query: codeString)
        }
        
        /*
         // display alert controller showing what was read
         if (metadataObjects.count > 0 && metadataObjects.first is AVMetadataMachineReadableCodeObject) {
         let scan = metadataObjects.first as! AVMetadataMachineReadableCodeObject
         
         let alertController = UIAlertController(title: "Barcode Scanned", message: scan.stringValue, preferredStyle: .alert)
         
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         
         present(alertController, animated: true, completion: nil)
         }
         */
        
    }
    
    
    // from back when user could toggle threshold value
    /*
     @IBAction func userTapped(sender: Any) {
     self.thresholdStackView.isHidden = !self.thresholdStackView.isHidden
     }
     
     @IBAction func sliderValueChanged(slider: UISlider) {
     self.recognitionThreshold = slider.value
     updateThreshholdLabel()
     }
     */
    
    func handleClassifications(request: VNRequest, error: Error?) {
        if let theError = error {
            print("Error: \(theError.localizedDescription)")
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // allClassifications is a huge string of all results
        let allClassifications = observations[0...4] // top 4 results
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > 0.0 ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")
        // print(allClassifications)
        
        // classifications is a string of results above set threshold
        // to be displayed on screen
        let classifications = observations[0...4] // top 4 results
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > recognitionThreshold ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")
        // print(classifications)
        
        DispatchQueue.main.async {
            
            // to print results continuously
            self.resultView.text = classifications
            
            // goal of this section is to set topMLResult to the top result
            // substring huge string by splitting into an array of strings
            // account for if the identifier is equal to or less than 1
            let resultViewArrayZero = allClassifications.characters.split{$0 == "0"}.map(String.init)
            let resultViewArrayOne = allClassifications.characters.split{$0 == "1"}.map(String.init)
            
            var resultForZero = ""
            var resultForOne = ""
            
            if resultViewArrayZero.count > 0 {
                resultForZero = resultViewArrayZero[0]
            }
            
            if resultViewArrayOne.count > 0 {
                resultForOne = resultViewArrayOne[0]
            }
            
            if resultForZero.characters.count < resultForOne.characters.count {
                self.topMLResult = resultForZero
            } else {
                self.topMLResult = resultForOne
            }
            
            // for debugging purposes
            // print(self.topMLResult)
        }
    }
    
    @IBAction func captureAction(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .on
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.isAutoStillImageStabilizationEnabled = true
        if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
            photoSettings.previewPhotoFormat = [ kCVPixelBufferPixelFormatTypeKey as String : photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            // ...
            // Code for photo capture goes here...
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                // ...
                // Process the image data (sampleBuffer) here to get an image file we can put in our captureImageView
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
                    // ...
                    // Add the image to captureImageView here...
                    self.imageToPass = image
                    print(image)
                    // print(self.imageToPass)
                    self.performSegue(withIdentifier: "capturedSegue", sender: self)
                }
            })
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
            self.previewLayer.removeFromSuperlayer()
            // self.previewLayer = nil
            self.session.stopRunning()
            
            let dvc = segue.destination as! PhotoViewController
            dvc.backgroundImage = imageToPass
            dvc.topMLResult = topMLResult
        }
        // only happens when barcode recognized and user clicks scan
        if segue.identifier == "barcodeToPreviewSegue" {
            self.previewLayer.removeFromSuperlayer()
            // self.previewLayer = nil
            self.session.stopRunning()
            
            let dvc = segue.destination as! PreviewViewController
            dvc.nameString = self.nameString
            dvc.priceString = self.priceString
            dvc.pictureUrl = self.pictureUrl
            // for debugging purposes
            // print(self.pictureUrl)
        }
    }
}

