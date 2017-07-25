//
//  DescriptionViewController.swift
//  
//
//  Created by Xiuya Yao on 7/23/17.
//

import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {
    
    let nameAlertController = UIAlertController(title: "Max Characters Reached", message: "Item name CANNOT exceed 500 characters", preferredStyle: .alert)
    
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    
    @IBOutlet weak var conditionSegCtrl: UISegmentedControl!
    
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toSelectMarketSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        itemDescription.delegate = self
        
        // change font of words in segmented control
        let font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightSemibold)
        conditionSegCtrl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
 
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
            charCountLabel.text = "Item Name: (1 character remaining)"
        } else if count <= 500 {
            charCountLabel.text = "Item Name: (" + String(remainingCount) + " characters remaining)"
        } else {
            charCountLabel.text = "Item Name: (0 characters remaining)"
            self.present(self.nameAlertController, animated: true)
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
