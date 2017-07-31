//
//  DescriptionViewController.swift
//  
//
//  Created by Xiuya Yao on 7/23/17.
//

import UIKit
import TwicketSegmentedControl

class DescriptionViewController: UIViewController, UITextViewDelegate, TwicketSegmentedControlDelegate {
    
    // to receive from price vc
    var itemName: String!
    var coverPhoto: UIImageView!
    var imageOne: UIImageView!
    var imageTwo: UIImageView!
    var imageThree: UIImageView!
    var imageFour: UIImageView!
    var isNegotiable: Bool!
    var itemPrice: Double!
    
    
    
    
    // tp pass onto next vc
    var isNew: Bool!
    
    // fancy segmented control!
    let segmentedControl = TwicketSegmentedControl()
    
    let nameAlertController = UIAlertController(title: "Max Characters Reached", message: "Item name CANNOT exceed 500 characters", preferredStyle: .alert)
    
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
  
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var testView: UIView!
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toChooseLocationSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style navigation bar
        self.title = "Item Description"
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // make navbar translucent (remove bottom line)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Style text field
        itemDescription.layer.cornerRadius = 5
        itemDescription.layer.borderWidth = 1
        itemDescription.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 0.50).cgColor
        
        // Set delegate of text field
        itemDescription.delegate = self
        
        
        
        // NEW SEGMENTED CONTROL (Twicket)
    
//        let frame = CGRect(x: 200, y: 200, width: 200, height: 100)
        self.segmentedControl.delegate = self
        let options = ["Used", "New"]
        self.segmentedControl.setSegmentItems(options)
        
        font.withFace("Roman")
        self.segmentedControl.font = UIFont(descriptor: font, size: 18)
        self.segmentedControl.sliderBackgroundColor
            = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
//        segmentedControl.isSliderShadowHidden = true
        
        self.segmentedControl.frame = testView.frame
        
        view.addSubview(self.segmentedControl)

        
        // Style Next button
        nextButton.layer.cornerRadius = 5
    }
    
    func setNew(index: Int) {
        if index == 0 {
            self.isNew = false
        } else {
            self.isNew = true
        }
    }
    
    func didSelect(_ segmentIndex: Int) {
        print("changed selection?")
        setNew(index: segmentIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ itemName: UITextView) {
        let text = itemName.text!
        let remainingCount = 500 - text.characters.count
        let count = text.characters.count
        
        if count == 499
        {
            charCountLabel.text = "What are you selling? (1 character remaining)"
        } else if count <= 500 {
            charCountLabel.text = "What are you selling? (" + String(remainingCount) + " characters remaining)"
        } else {
            charCountLabel.text = "What are you selling? (0 characters remaining)"
            self.present(self.nameAlertController, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toChooseLocationSegue" {
            
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.tintColor = UIColor.black
            navigationItem.backBarButtonItem = backItem
            
            // make sure isNew is set to the correct selection
            setNew(index: self.segmentedControl.selectedSegmentIndex)
            
            let dvc = segue.destination as! ChooseLocationViewController
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
        }
    }

}
