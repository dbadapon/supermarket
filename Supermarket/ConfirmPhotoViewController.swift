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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePreview.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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