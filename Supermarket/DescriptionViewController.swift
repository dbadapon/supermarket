//
//  DescriptionViewController.swift
//  
//
//  Created by Xiuya Yao on 7/23/17.
//

import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {
    
    // to receive from price vc
    var itemName: UITextView!
    var coverPhoto: UIImageView!
    var imageOne: UIImageView!
    var imageTwo: UIImageView!
    var imageThree: UIImageView!
    var imageFour: UIImageView!
    var isNegotiable: Bool!
    var itemPrice: Double!
    
    // tp pass onto next vc
    var isNew: Bool!
    // as well as itemDescription
    
    let nameAlertController = UIAlertController(title: "Max Characters Reached", message: "Item name CANNOT exceed 500 characters", preferredStyle: .alert)
    
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBOutlet weak var conditionSegCtrl: UISegmentedControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    

    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toChooseLocationSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style navigation bar
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        self.title = "Item Description"
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
        
        
        // change font of words in segmented control
        let segFont = UIFont.systemFont(ofSize: 24, weight: UIFontWeightSemibold)
        conditionSegCtrl.setTitleTextAttributes([NSFontAttributeName: segFont], for: .normal)
        
        // Style Next button
        nextButton.layer.cornerRadius = 5
        
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
            if self.conditionSegCtrl.selectedSegmentIndex == 1 {
                self.isNew = true
            } else {
                self.isNew = false
            }
            
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
