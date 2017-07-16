//
//  NewPostDescriptionViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class NewPostDescriptionViewController: UIViewController {
    
    var image: UIImage?
    var name: String!
    var negotiable: Bool?
    var conditionNew: Bool?
    var price: Double?
    var itemDescription: String?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print ("view did load in the new window is running")
        
        nameField.text = name
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNext(_ sender: Any) {
        // check to see some stuff is nil
        conditionNew = true
        negotiable = true
        price = 35
        itemDescription = "placeholder description for the item"
        performSegue(withIdentifier: "toMarketSelection", sender: self)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toMarketSelection" {
            self.name = nameField.text
            let destination = segue.destination as! NewPostMarketViewController
            destination.name = self.name
            destination.image = self.image
            destination.conditionNew = self.conditionNew
            destination.negotiable = self.negotiable
            destination.itemDescription = self.itemDescription!
            destination.price = self.price
            
        }
        
    }
 

}
