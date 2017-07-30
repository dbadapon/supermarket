//
//  ChooseLocationViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ChooseLocationViewController: UIViewController {
    
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
    @IBOutlet weak var mapViewFrame: UIView!
    @IBOutlet weak var tempMap: UIImageView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var getLocationButton: UIButton!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var setButton: UIButton!
    
    @IBAction func didTapLocation(_ sender: Any) {
        print("get current location")
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        // how to go back without dismissing...
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSelectMarketSegue", sender: self)
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
        
        // Google Map view
        // first hard-code the location so that you know how to use google maps
        // then go back and look at you core location code to get the current location
        
        let mapView = MKMapView(frame: mapViewFrame.frame)
        view.addSubview(mapView)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSelectMarketSegue" {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backItem
            
            let dvc = segue.destination as! SelectMarketViewController
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
