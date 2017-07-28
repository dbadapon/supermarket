//
//  ChooseLocationViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class ChooseLocationViewController: UIViewController {
    
    // to receive from description vc
    var itemName: UITextView!
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
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var tempMap: UIImageView!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var getLocationButton: UIButton!
    @IBOutlet weak var zipCodeField: UITextField!
    
    @IBAction func didTapLocation(_ sender: Any) {
        print("get current location")
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSelectMarketSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationButton.layer.cornerRadius = 3
        zipCodeField.layer.cornerRadius = 3

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSelectMarketSegue" {
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
