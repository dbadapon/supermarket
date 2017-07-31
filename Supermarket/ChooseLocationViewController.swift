//
//  ChooseLocationViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NVActivityIndicatorView

class ChooseLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NVActivityIndicatorViewable {
    
    // activity indicator view frame
    
    @IBOutlet weak var activityIndicatorViewFrame: UIView!
    var activityIndicator: NVActivityIndicatorView?
    var isAnimating: Bool?
    
    
    // to receive from description vc
    var itemName: String!
    var coverPhoto: UIImageView!
    var imageOne: UIImageView!
    var imageTwo: UIImageView!
    var imageThree: UIImageView!
    var imageFour: UIImageView!
    var isNegotiable: Bool!
    var itemPrice: Double!
    var isNew: Bool!
    var itemDescription: UITextView!
    
    // to pass to next vc
    var latitude: Double?
    var longitude: Double?
    var city: String?
    
    
    // Map stuff on storyboard
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tempMap: UIImageView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var getLocationButton: UIButton!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var setButton: UIButton!
    
    // Map configuration
    var locationManager: CLLocationManager!
    var pinLocation: CLLocationCoordinate2D? {
        didSet {
            print("set pin location!")
        }
    }
    

    @IBAction func movePin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let locCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        self.pinLocation = locCoord
        
        
        let annotation = MKPointAnnotation()
        
        
        annotation.coordinate = locCoord
        annotation.title = "Here!"
        annotation.subtitle = "Set pickup"
        
        self.mapView.removeAnnotations(mapView.annotations) // add only one point
        
        self.mapView.addAnnotation(annotation)
        
        self.latitude = Double(locCoord.latitude)
        self.longitude = Double(locCoord.longitude)
        
    }
    
    
    @IBAction func didTapLocation(_ sender: Any) {
        print("get current location")
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        // how to go back without dismissing...
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
//        self.activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        self.activityIndicator!.color = .black
//        self.activityIndicator!.type = NVActivityIndicatorType.ballPulse
//        self.activityIndicator!.startAnimating()
//        self.isAnimating = self.activityIndicator?.isAnimating
//        view.addSubview(activityIndicator!)
//        print("animating? \(self.activityIndicator?.isAnimating)")
        
        startAnimating(type: NVActivityIndicatorType.ballPulse)
        
        if self.pinLocation != nil {
            // set city to pin location city
            print("about to get the city from pin!")
            coordinateToCity()
            print("now the city is: \(self.city)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style navigation bar
        self.title = "Location"
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // make navbar translucent (remove bottom line)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // style button and text field
        getLocationButton.layer.cornerRadius = 5
        zipCodeField.layer.cornerRadius = 5
        zipCodeField.layer.borderWidth = 1
        zipCodeField.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 0.50).cgColor
        
        // style Set button
        setButton.layer.cornerRadius = 5
        
        // Configure map view
        // first hard-code the location so that you know how to use google maps
        // then go back and look at you core location code to get the current location
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
    }
    
    func determineCurrentLocation() {
        print("Determining current location!")
        locationManager = CLLocationManager()
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        if self.pinLocation == nil {
            self.pinLocation = center
//            let annotation: MKPointAnnotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
//            annotation.title = "LE PIN"
//            mapView.addAnnotation(annotation)
        }
        
        
        
        print("USER LOCATION: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)

//         allow the user to just move the location pin...
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting current location: \(error.localizedDescription)")
    }
    
    func coordinateToCity() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: (self.pinLocation?.latitude)!, longitude: (self.pinLocation?.longitude)!)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            var placemark: CLPlacemark!
            placemark = placemarks?[0]
   
            let coordinateCity = placemark.locality
            let coordinateState = placemark.administrativeArea
            
            let cityString = "\(coordinateCity!), \(coordinateState!)"
            print("cityString is: \(cityString)")
            self.city = cityString
//            destination.city = cityString
            
//            self.activityIndicator?.stopAnimating()
//            self.isAnimating = self.activityIndicator?.isAnimating
            print("animating? \(self.activityIndicator?.isAnimating)")
            self.stopAnimating()
            self.performSegue(withIdentifier: "toSelectMarketSegue", sender: self)
            
            // YOU NEED AN ACTIVITY INDICTATOR THAT GETS TRIGGERED WHEN USER HITS SET!!
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dvc = segue.destination as! SelectMarketViewController
        
        if segue.identifier == "toSelectMarketSegue" {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backItem
            
            dvc.itemName = self.itemName
            dvc.coverPhoto = self.coverPhoto
            dvc.imageOne = self.imageOne
            dvc.imageTwo = self.imageTwo
            dvc.imageThree = self.imageThree
            dvc.imageFour = self.imageFour
            dvc.isNegotiable = self.isNegotiable
            dvc.itemPrice = self.itemPrice
            dvc.isNew = self.isNew
            dvc.itemDescription = self.itemDescription
            dvc.latitude = self.latitude
            dvc.longitude = self.longitude
            dvc.city = self.city
        }
    }
}
