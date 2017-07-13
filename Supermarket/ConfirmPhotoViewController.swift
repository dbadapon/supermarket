//
//  ConfirmPhotoViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/12/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class ConfirmPhotoViewController: UIViewController {
    
    var image: UIImage!
    @IBOutlet weak var imagePreview: UIImageView!
    var name: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePreview.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUsePhoto(_ sender: Any) {
        name = MLManager.getName(withImage: image)
        performSegue(withIdentifier: "toItemDescription", sender: self)
    }
    
    @IBAction func onRetake(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toItemDescription" {
            let destination = segue.destination as! NewPostDescriptionViewController
            destination.image = self.image
            destination.name = self.name
        }
    }
 

}
