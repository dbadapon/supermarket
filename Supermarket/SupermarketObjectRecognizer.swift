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
    // var objectToTrack: VNDetectedObjectObservation
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
    // to be updated and displayed continuously
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
    // what is the difference between: private (set) var recognizedObject: RecognizedObject? { and below???
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
    var recognitionThreshold : Float = 0.19
    var highRecognitionThreshold : Float = 0.49
    
    // corresponding to RecognizedObject
    
    // var boundingBox = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    // continuously changes as different objects are recognized
    var highProbabilityMLResult = ""
    // go ahead and set this in case whole string is needed
    var highProbClassifications = ""
    // for box around recognized object
    var visionSequenceHandler = VNSequenceRequestHandler()
    var lastObservation: VNDetectedObjectObservation?
    var highProbExists = false
    // ANOTHER METHOD FOR BOX AROUND RECOGNIZED OBJECT
    // detects rectangles in consecutive frames as opposed to trying
    // to track an object in live camera feed
    // does not work as well, so probably a no on this
    var rectanglesSequenceHandler = VNSequenceRequestHandler()
    // private var latestBuffer: CMSampleBuffer!
    
    // save current one for when high probability object recognized
    // this will be the object that a box is put around
    var currentHighProbabilityMLResult = ""
    var currentHighProbClassifications = ""
    
    // corresponding to RecognizedBarcode
    // no need
    // var barcodeObject: AVMetadataMachineReadableCodeObject
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
            
            // ADDED CODE
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
        // at the end, need to set attributes of RecognizedObject
        // TEMPORARY HARDCODED VALUES
        // self.primaryRecognizedObject = RecognizedObject.init(label: "", boundingBox: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.printThis), userInfo: nil, repeats: true)
    } // end of init
    
//    func printThis() {
//        print ("hey it's here still running")
//        print (self.device)
//        print (self.delegate)
//        print (self.session.isRunning)
//        if self.session.isInterrupted {
//            print ("---WOOOOOWWW THE SESSION WAS INTERRUPTED---")
//        }
//    }
    
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
            // Code for photo capture goes here...
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
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
    
    /*
    // for tracking rectangles
    var rectangleViews: Array<UIView> = []
    
    private func gotRectangles(request: VNRequest, error: Error?) {
        print("Got rectangles: ",request.results!)
        DispatchQueue.main.async {
            // make sure we have an actual result
            let _ = request.results?.map() { result in
                guard let newRectObv = result as? VNRectangleObservation else { return }
                //                var transformedRect = newObservation.boundingBox
                //                transformedRect.origin.y = 1 - transformedRect.origin.y
//                let convertedRect = self.cameraLayer.layerRectConverted(fromMetadataOutputRect: newRectObv.boundingBox)
//                let view =  UIView(frame: convertedRect)
//                view.backgroundColor = UIColor.clear
//                view.layer.borderWidth = 2.0
//                view.layer.borderColor = UIColor.black.cgColor
//                self.view.addSubview(view)
                // self.recognizedObject = RecognizedObject.init(boundingBox: newRectObv.boundingBox, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
                if self.highProbabilityMLResult != "" {
                    if self.highProbabilityMLResult != self.currentHighProbabilityMLResult {
                        print("NEW OBSERVATION, SO LAST OBSERVATION SET TO NIL")
                        // self.lastObservation = nil
                        // high prob results have changed, so save then and initialize a tracker
                        // save the current high probability results
                        self.currentHighProbabilityMLResult = self.highProbabilityMLResult
                        self.currentHighProbClassifications = self.highProbClassifications
                        print(self.highProbabilityMLResult)
                        self.delegate?.highProbObjectRecognized(isRecognized: true)
                        self.highProbExists = true
                        // set the observation
                        // vision system is sensitive to the width and height of the rectangle we pass in
                        // closer the rectangle surrounds the object = better the system will be able to track it
                        // let initialRect = CGRect(x: 0.29, y: 0.252, width: 0.534, height: 0.467)
                        // will show rectangle that's (105.375, 193.43, 175.125, 356.178)
                        // var initialRect = CGRect(x: 0.29, y: 0.252, width: 0.534, height: 0.467)
                        // convert from AVFoundation coordinate space to Vision coordinate space
                        // initialRect.origin.y = 1 - initialRect.origin.y
                        // let newObservation = VNDetectedObjectObservation(boundingBox: initialRect)
                        // print("HIGH PROB RESULT EXISTS AND INITIAL TRACKER INSTANTIATED")
                        // print(initialRect)
                        // self.lastObservation = newObservation
                        // call on delegate
                        // self.recognizedObject = RecognizedObject.init(boundingBox: newRectObv.boundingBox, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
                        print("NEW RECTANGLE DETECTED")
                    }
                } else {
                    // self.lastObservation = nil // no need to do this
                    // print("last observation set to nil bc no highProbObj anymore")
                    self.currentHighProbabilityMLResult = ""
                    self.highProbExists = false
                    self.delegate?.highProbObjectRecognized(isRecognized: false)
                }
            }
        }
    }
 */
    
    // check if barcode is in Walmart API
    func checkPriceWithBarcode(query: String) {
        
        let baseURL = "http://api.walmartlabs.com/v1/search?query="
        let endUrl = "&format=json&apiKey=yva6f6yprac42rsp44tjvxjg"
        
        let newString = query.replacingOccurrences(of: " ", with: "+")
        
        print(newString)
        let wholeUrl = baseURL + newString + endUrl
        
        request(wholeUrl, method: .get).validate().responseJSON { (response) in
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
                        self.pictureUrl = imageUrl
                        print ("THIS IS THE IMAGE URL: \(imageUrl)")
                        
                        self.nameString = String(describing: item["name"]!)
                        self.priceString = "$" + String(describing: item["salePrice"]!)
                        print (item["salePrice"]!)
                        
                        self.recognizedBarcode = RecognizedBarcode.init(codeString: self.codeString, nameString: self.nameString, priceString: self.priceString, pictureUrl: self.pictureUrl)
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
    
//        guard
//            // make sure the pixel buffer can be converted
//            let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
//            // make sure that there is a previous observation we can feed into the request
//            let lastObservation = self.lastObservation
//        else { return }
        
        
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
                
                
                // right now, this is happening forever
                // FIX THIS AFTER LUNCH!!!!!!
                // perform the request

                do {
//                    let visionSequenceHandler = VNSequenceRequestHandler()
//                    try visionSequenceHandler.perform([request], on: pixelBuffer)
                    try self.visionSequenceHandler.perform([request], on: pixelBuffer)
                    print("visionSequenceHandler success!!!")
                } catch {
                    print("Throws: \(error)")
                }

            }
        /*
            // below is code for identifying rectangles
            let request = VNDetectRectanglesRequest(completionHandler: self.gotRectangles)
            do {
                try rectanglesSequenceHandler.perform([request], on: pixelBuffer)
            } catch {
                print("Throws: \(error)")
            }
  */
        }
    }
    
    func handleClassifications(request: VNRequest, error: Error?) {
        
        // print ("it's getting to the handle classifications function")

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
        // print(classifications)
        
        // allClassifications is a huge string of all results
        let allClassifications = observations[0...4] // top 4 results
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > 0.0 ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")
        // print(allClassifications)
        
        // highProbClassifications contains only results above the highRecognitionThreshold
        let highProbClassifications = observations[0...4] // top 4 results, CHANGE THIS!!!
            .flatMap({ $0 as? VNClassificationObservation })
            .flatMap({$0.confidence > highRecognitionThreshold ? $0 : nil})
            .map({ "\($0.identifier) \(String(format:"%.2f", $0.confidence))" })
            .joined(separator: "\n")
        // print(highProbClassifications)
        
        DispatchQueue.main.async {
            
            // to print results continuously
            self.classifications = classifications
            // print(self.classifications)
            
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
            // for debugging purposes
            // print(self.topMLResult)
            
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

            
//            if self.highProbabilityMLResult != "" {
//                if self.highProbabilityMLResult != self.currentHighProbabilityMLResult {
//                    print("NEW OBSERVATION, SO LAST OBSERVATION SET TO NIL")
//                    self.lastObservation = nil
//                    // high prob results have changed, so save then and initialize a tracker
//                    // save the current high probability results
//                    self.currentHighProbabilityMLResult = self.highProbabilityMLResult
//                    self.currentHighProbClassifications = self.highProbClassifications
//                    print(self.highProbabilityMLResult)
//                    // self.delegate?.highProbObjectRecognized(isRecognized: true)
//                    self.highProbExists = true
//                    // set the observation
//                    let initialRect = CGRect(x: 0.45, y: 0.60, width: 0.24, height: 0.32)
//                    let newObservation = VNDetectedObjectObservation(boundingBox: initialRect)
//                    print("HIGH PROB RESULT EXISTS AND INITIAL TRACKER INSTANTIATED")
//                    self.lastObservation = newObservation
//                    // call on delegate
//                    print ("it's about to set a recognized object")
//                    self.recognizedObject = RecognizedObject.init(boundingBox: initialRect, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
//                }
//            } else {
//                // self.lastObservation = nil // no need to do this
//                // print("last observation set to nil bc no highProbObj anymore")
//                self.currentHighProbabilityMLResult = ""
//                self.highProbExists = false
//                self.delegate?.highProbObjectRecognized(isRecognized: false)
//            }

            if self.highProbabilityMLResult != "" {
                if self.highProbabilityMLResult != self.currentHighProbabilityMLResult {
                    print("NEW OBSERVATION, SO LAST OBSERVATION SET TO NIL")
                    self.lastObservation = nil
                    self.visionSequenceHandler = VNSequenceRequestHandler()
                    // high prob results have changed, so save then and initialize a tracker
                    // save the current high probability results
                    self.currentHighProbabilityMLResult = self.highProbabilityMLResult
                    self.currentHighProbClassifications = self.highProbClassifications
                    print(self.highProbabilityMLResult)
                    // self.delegate?.highProbObjectRecognized(isRecognized: true)
                    self.highProbExists = true
                    // set the observation
                    // vision system is sensitive to the width and height of the rectangle we pass in
                    // closer the rectangle surrounds the object = better the system will be able to track it
                    // let initialRect = CGRect(x: 0.29, y: 0.252, width: 0.534, height: 0.467)
                    // will show rectangle that's (105.375, 193.43, 175.125, 356.178)
                    var initialRect = CGRect(x: 0.29, y: 0.252, width: 0.534, height: 0.467)
                    // convert from AVFoundation coordinate space to Vision coordinate space
                    initialRect.origin.y = 1 - initialRect.origin.y
                    let newObservation = VNDetectedObjectObservation(boundingBox: initialRect)
                    print("HIGH PROB RESULT EXISTS AND INITIAL TRACKER INSTANTIATED")
                    print(initialRect)
                    self.lastObservation = newObservation
                    
                    var initialboundingbox = CGRect(x: 0.29, y: 0.748, width: 0.534, height: 0.467)
                    initialboundingbox.origin.y = 1 - initialboundingbox.origin.y
                    // call on delegate
                    self.recognizedObject = RecognizedObject.init(boundingBox: initialboundingbox, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
                }
            } else {
                // self.visionSequenceHandler = VNSequenceRequestHandler()
                // self.lastObservation = nil // no need to do this
                // print("last observation set to nil bc no highProbObj anymore")
                self.currentHighProbabilityMLResult = ""
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
                // hide the rectangle when we lose accuracy so the user knows something is wrong
                // self.highlightView?.frame = .zero
                print("last observation set to nil")
                // reset the tracker
                self.visionSequenceHandler = VNSequenceRequestHandler()
                self.lastObservation = nil
                self.currentHighProbabilityMLResult = ""
                self.highProbExists = false
                self.delegate?.highProbObjectRecognized(isRecognized: false)
                return
            }
            
            // calculate view rect
            var transformedRect = newObservation.boundingBox
            transformedRect.origin.y = 1 - transformedRect.origin.y
            
            // pass tranformedRect back to delegate
            // TEMPORARILY COMMENTED OUT TO TEST GOT RECTANGLES
            self.recognizedObject = RecognizedObject.init(boundingBox: transformedRect, highProbabilityMLResult: self.currentHighProbabilityMLResult, highProbClassifications: self.currentHighProbClassifications)
                
            // do this in delegate
            // let convertedRect = self.cameraLayer.layerRectConverted(fromMetadataOutputRect: transformedRect)
            // move the highlight view
            // self.highlightView?.frame = convertedRect
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
}
