//
//  PriceViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class PriceViewController: UIViewController, UITextFieldDelegate {
    
    // color to use for app
    let textColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha:1.0)
    
    let priceAlertController = UIAlertController(title: "Error", message: "Please set a valid price", preferredStyle: .alert)
    
    @IBOutlet weak var inputPrice: UITextField!
    
    @IBOutlet weak var negotiableSwitch: UISwitch!
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toDescriptionSegue", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputPrice.keyboardType = UIKeyboardType.decimalPad
        inputPrice.tintColor = textColor
        inputPrice.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PriceViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        
        // add the OK action to the alert controller
        priceAlertController.addAction(OKAction)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ inputPrice: UITextField) {
        print("MOO")
        
        let text = inputPrice.text!
        let num = Double(inputPrice.text!)
        let count = text.characters.count
        
        if count <= 38 && num != nil
        {
            // value is okay
            // running into errors here
            // can't switch back to number
            /*
            let price = Double(inputPrice.text!)! as NSNumber
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            // formatter.locale = NSLocale.currentLocale() // This is the default
            // In Swift 4, this ^ has been renamed to simply NSLocale.current
            self.inputPrice.text = formatter.string(from: price) // ex. "$123.44"
            */
        } else {
            // insert alert controller because number is too large or invalid
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
