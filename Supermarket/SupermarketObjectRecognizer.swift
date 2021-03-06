//
//  SupermarketObjectRecognizer.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/28/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import Alamofire

struct RecognizedObject {
    var boundingBox: CGRect
    var highProbabilityMLResult: String
    var highProbClassifications: String
}

struct RecognizedBarcode {
    var codeString: String
    var nameString: String
    var priceString: String
    var pictureUrl: String
}

struct CurrentFrame {
    var classifications: String
    var topMLResult: String
}

protocol SupermarketObjectRecognizerDelegate: class {
    func getRecognizedObject(recognizedObject: RecognizedObject)
    func updateRecognizedBarcode(recognizedBarcode: RecognizedBarcode)
    func updateCurrentFrame(currentFrame: CurrentFrame)
    func captureAndSegue(screenshot: UIImage)
    func getBarcodeObject(barcodeObject: AVMetadataMachineReadableCodeObject)
    func barcodeObjectExists(doesExist: Bool)
    func highProbObjectRecognized(isRecognized: Bool)
}

class SupermarketObjectRecognizer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var delegate: SupermarketObjectRecognizerDelegate?
    
    // this is calling the delegate
    // sends a RecognizedObject back to delegate
    // every time primaryRecognizedObject is set, delegate method is called
    // what is the difference between: private (set) var recognizedObject: RecognizedObject? { and below?
    var recognizedObject: RecognizedObject? {
        didSet {
            delegate?.getRecognizedObject(recognizedObject: recognizedObject!)
        }
    }
    
    var recognizedBarcode: RecognizedBarcode? {
        didSet {
            delegate?.updateRecognizedBarcode(recognizedBarcode: recognizedBarcode!)
        }
    }
    
    var currentFrame: CurrentFrame? {
        didSet {
            // didSet is called on whenever currentFrame changes
            delegate?.updateCurrentFrame(currentFrame: currentFrame!)
        }
    }
    
    // class variables
    // video capture session
    private let device: AVCaptureDevice
    
    // video capture session
    var session = AVCaptureSession()
    // types of barcodes to read and recognize
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
    
    var captureQueue = DispatchQueue(label: "captureQueue")
    var visionRequests = [VNRequest]()
    // for ML model
    var recognitionThreshold : Float = 0.22
    var highRecognitionThreshold : Float = 0.44
    
    // corresponding to RecognizedObject
    // continuously changes as different objects are recognized
    var highProbabilityMLResult = ""
    // go ahead and set this in case whole string is needed
    var highProbClassifications = ""
    // for box around recognized object
    var visionSequenceHandler = VNSequenceRequestHandler()
    var lastObservation: VNDetectedObjectObservation?
    var highProbExists = false
    
    // save current one for when high probability object recognized
    // this will be the object that a box is put around
    var currentHighProbabilityMLResult = ""
    var currentHighProbClassifications = ""
    
    // corresponding to RecognizedBarcode
    // what is read from barcode
    var codeString = ""
    // name of object from querying codeString
    var nameString = ""
    // price of object from querying codeString
    var priceString = ""
    // var lastQuery: String?
    // image url of object from querying codeString
    var pictureUrl = ""
    
    // corresponding to CurrentFrame
    // huge string of classifications to be displayed in resultView
    var classifications = ""
    var topMLResult = ""
    
    // for capturing image
    // added code to capture image
    let stillImageOutput = AVCaptureStillImageOutput()
    // image to pass onto next view controller
    // to "freeze" screen when user clicks capture button
    // this is the screenshot to be taken
    var imageToPass = UIImage()
    
    
    // init is when SupermarketObjectRecognizer is created
    init(passedDevice: AVCaptureDevice) {
        print ("it's instantiating a new recognizer")
        
        // Xiuya: Implement this
        device = passedDevice
        
        // call super.init() immediately after all subclass properties are initialized
        super.init()
        
        do {
            // create the capture input and the video output
            let cameraInput = try AVCaptureDeviceInput(device: device)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            session.sessionPreset = AVCaptureSessionPresetHigh
            
            // wire up the session
            session.addInput(cameraInput)
            session.addOutput(videoOutput)

            // add photo output
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
            
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
                print("session can accept stillImageOutput")
                // Configure the Live Preview here...
            } else {
                print("session cannot accept stillImageOutput")
            }
            
            // beginning of code for barcode and QR code scanning
            // initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            session.addOutput(captureMetadataOutput)
            
            // set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // end of code for barcode and QR code scanning
            
            // make sure we are in portrait mode
            let conn = videoOutput.connection(withMediaType: AVMediaTypeVideo)
            conn?.videoOrientation = .portrait
            
            // Start the session
            session.startRunning()
            
            // set up the vision model
            guard let resNet50Model = try? VNCoreMLModel(for: Resnet50().model) else {
                fatalError("could not load model")
            }
            
            // set up the request using our vision model
            
            let classificationRequest = VNCoreMLRequest(model: resNet50Model, completionHandler: handleClassifications)
            classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
            visionRequests = [classificationRequest]
            
        } catch {
            fatalError(error.localizedDescription)
        }
    } // end of init
    
    // public function that can be called from create post vc
    func captureScreenshot() {
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .on
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.isAutoStillImageStabilizationEnabled = true
        
        if photoSettings.__availablePreviewPhotoPixelFormatTypes.count > 0 {
            photoSettings.previewPhotoFormat = [ kCVPixelBufferPixelFormatTypeKey as String : photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) -> Void in
                // Process the image data (sampleBuffer) here to get an image file we can put in our captureImageView
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
                    // Add the captured image to imageToPass
                    self.imageToPass = image
                    // for debugging purposes
                    // print(self.imageToPass)
                    self.delegate?.captureAndSegue(screenshot: image)
                }
            })
        }
    }
    
    // check if barcode is in Walmart API
    func checkPriceWithBarcode(query: String) {
        
        let baseURL = "http://api.walmartlabs.com/v1/search?query="
        let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
        
        let newString = query.replacingOccurrences(of: " ", with: "+")
        
        print(newString)
        let wholeUrl = baseURL + newString + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { [weak weakSelf = self] (response) in
            if response.result.isSuccess,
                let responseDictionary = response.result.value as? [String: Any] {
                let numberOfItems = responseDictionary["numItems"] as! Int
                
                // number of items from query
                if numberOfItems == 0 {
                    print("not getting a response with barcode from Walmart API")
                }
                // at least one result from query
                if numberOfItems > 0 {
                    let itemArray = responseDictionary["items"] as! [[String: Any]]
                    
                    let item = itemArray[0]
                    
                    if item["imageEntities"] != nil {
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
                        weakSelf?.pictureUrl = imageUrl
                        print ("THIS IS THE IMAGE URL: \(imageUrl)")
                        
                        weakSelf?.nameString = String(describing: item["name"]!)
                        weakSelf?.priceString = "$" + String(describing: item["salePrice"]!)
                        print (item["salePrice"]!)
                        
                        if let strongSelf = weakSelf {
                            strongSelf.recognizedBarcode = RecognizedBarcode(codeString: strongSelf.codeString, nameString: strongSelf.nameString, priceString: strongSelf.priceString, pictureUrl: strongSelf.pictureUrl)
                        }
                    }
                }
            } else {
                print("barcode not found in Walmart API")
            }
        }
    }
    
    // delegate method for AVCaptureVideoDataOutputSampleBufferDelegate
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
            print("ERROR HERE")
            print(error)
        }
        
        if self.highProbExists {
            // below is code for tracking object
            // create the request
            if let lastObservation = self.lastObservation {
                print("high prob exists and last observation has been set")
                let request = VNTrackObjectRequest(detectedObjectObservation: lastObservation, completionHandler: self.handleVisionRequestUpdate)
                // set the accuracy to high
                // this is slower, but it works a lot better
                request.trackingLevel = .accurate

                do {
                    try self.visionSequenceHandler.perform([request], on: pixelBuffer)
                    print("visionSequenceHandler success!!!")
                } catch {
                    print("Throws: \(error)")
                }
            }
        }
    }
    
    func handleClassifications(request: VNRequest, error: Error?) {

        if let theError = error {
            print("Error: \(theError.localizedDescription)")
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // original code only had this
        // classifications is a string of results above set threshold
        // to be displayed on screen
        let classifications = observations[0...4] // top 4 results
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > recognitionThreshold ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        // allClassifications is a huge string of all results
        let allClassifications = observations[0...4] // top 4 results
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > 0.0 ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")

        // highProbClassifications contains only results above the highRecognitionThreshold
        let highProbClassifications = observations[0...4] // top 4 results, CHANGE THIS!!!
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > highRecognitionThreshold ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        DispatchQueue.main.async {
            
            // to show results continuously
            self.classifications = classifications
            
            // goal of this section is to set topMLResult to the top result
            // substring huge string by splitting into an array of strings
            // account for if the identifier is equal to or less than 1
            // there will be a topMLResult regardless recognitionThreshold
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
            
            // update classifications to be passed onto delegate
            self.currentFrame = CurrentFrame(classifications: self.classifications, topMLResult: self.topMLResult)
            
            // be able to access high probability classifications
            self.highProbClassifications = highProbClassifications
            // print(self.highProbClassifications)
            
            // goal of this section is to set highProbabilityMLResult
            // if there is one above the highRecognitionThreshold
            let highProbResultViewArrayZero = highProbClassifications.characters.split{$0 == "0"}.map(String.init)
            let highProbResultViewArrayOne = highProbClassifications.characters.split{$0 == "1"}.map(String.init)
                
            var highProbResultForZero = ""
            var highProbResultForOne = ""
                
            if highProbResultViewArrayZero.count > 0 {
                highProbResultForZero = highProbResultViewArrayZero[0]
            }
                
            if highProbResultViewArrayOne.count > 0 {
                highProbResultForOne = highProbResultViewArrayOne[0]
            }
                
            if highProbResultForZero.characters.count < highProbResultForOne.characters.count {
                self.highProbabilityMLResult = highProbResultForZero
            } else {
                self.highProbabilityMLResult = highProbResultForOne
            }
            
            if self.highProbabilityMLResult == "banana " {
                self.highProbabilityMLResult = "banana\n(NOT HOTDOG!)"
            }

            if self.highProbabilityMLResult != "" {
                if self.highProbabilityMLResult != self.currentHighProbabilityMLResult {
                    
                    self.highRecognitionThreshold = 0.33
                    self.highProbExists = true
                    self.delegate?.highProbObjectRecognized(isRecognized: true)
                    
                    print("NEW OBSERVATION, SO RESET STUFF")
                    self.lastObservation = nil
                    self.visionSequenceHandler = VNSequenceRequestHandler()
                    
                    // high prob results have changed, so save then and initialize a tracker
                    // save the current high probability results
                    self.currentHighProbabilityMLResult = self.highProbabilityMLResult
                    self.currentHighProbClassifications = self.highProbClassifications
                    print(self.highProbabilityMLResult)
                    
                    // set the observation
                    // vision system is sensitive to the width and height of the rectangle we pass in
                    // closer the rectangle surrounds the object = better the system will be able to track it
                    // let initialRect = CGRect(x: 0.29, y: 0.252, width: 0.534, height: 0.467)
                    // will show rectangle that's (105.375, 193.43, 175.125, 356.178)
                    var initialRect = CGRect(x: 0.345, y: 0.324, width: 0.36, height: 0.32)
                    // convert from AVFoundation coordinate space to Vision coordinate space
                    initialRect.origin.y = 1 - initialRect.origin.y
                    let newObservation = VNDetectedObjectObservation(boundingBox: initialRect)
                    print("HIGH PROB RESULT EXISTS AND INITIAL TRACKER INSTANTIATED")
                    print(initialRect)
                    self.lastObservation = newObservation
                    
                    var initialBoundingBox = CGRect(x: 0.345, y: 0.676, width: 0.36, height: 0.32)
                    initialBoundingBox.origin.y = 1 - initialBoundingBox.origin.y
                    
                    // call on delegate
                    self.recognizedObject = RecognizedObject.init(boundingBox: initialBoundingBox, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
                }
            } else {
                self.highRecognitionThreshold = 0.44
                self.currentHighProbabilityMLResult = ""
                self.currentHighProbClassifications = ""
                self.highProbExists = false
                self.delegate?.highProbObjectRecognized(isRecognized: false)
            }
        }
    }
    
    func handleVisionRequestUpdate(_ request: VNRequest, error: Error?) {
        // only need to find main object if high probability object exists
        // so this is only called when highProbExists == true
        // dispatch to the main queue because we are touching non-atomic, non-thread safe properties of the view controller
        DispatchQueue.main.async {
            // make sure we have an actual result
            guard let newObservation = request.results?.first as? VNDetectedObjectObservation else { return }
            
            // prepare for next loop
            self.lastObservation = newObservation
            
            // check the confidence level before updating the UI
            guard newObservation.confidence >= 0.3 else {

                self.highRecognitionThreshold = 0.44
                self.currentHighProbabilityMLResult = ""
                self.highProbabilityMLResult = ""
                
                // probably unnecesary but just in case
                self.highProbClassifications = ""
                self.currentHighProbClassifications = ""
                
                self.highProbExists = false
                self.delegate?.highProbObjectRecognized(isRecognized: false)
                return
            }
            
            // calculate view rect
            var transformedRect = newObservation.boundingBox
            transformedRect.origin.y = 1 - transformedRect.origin.y
            
            // pass tranformedRect back to delegate
            self.recognizedObject = RecognizedObject.init(boundingBox: transformedRect, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
        }
    }
    
    // delegate method for AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // for debugging purposes
        print("CAPTURED BARCODE")
        
        // Check that metadataObjects array contains at least one object.
        if metadataObjects.count == 0 {
            // qrCodeFrameView?.frame = CGRect.zero
            self.delegate?.barcodeObjectExists(doesExist: false)
            print("No QR code is detected")
            return
        }
        
        // else barcode object does exist
        self.delegate?.barcodeObjectExists(doesExist: true)
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // update delegate's barcode bounds
        self.delegate?.getBarcodeObject(barcodeObject: metadataObj)
        
        if metadataObj.stringValue != nil {
            self.codeString = metadataObj.stringValue!
        }
        
        // make query if barcode is read
        if self.codeString != "" {
            checkPriceWithBarcode(query: self.codeString)
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
    
    deinit {
        print("Calling deinit")
    }
}
