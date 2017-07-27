//
//  SelectMarketViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse

class SelectMarketViewController: UIViewController {
    
    // to receive from choose location vc
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
    var latitude: Double?
    var longitude: Double?
    var city: String?
    
    // before making post, check if any images are the placeholder image
    // meaning user did not select their own image
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        // performSegue(withIdentifier: "toChooseLocationSegue", sender: self)
        
        // let's hard-code the latitude and longitude for now... and city lol
        latitude = 33.640495
        longitude = -117.844296
        city = "Irvine, CA"
        isNew = true
        itemPrice = 25.70
        
        var tempImageList: [UIImage] = []
        tempImageList.append(coverPhoto.image!) // should I force unwrap this?
        tempImageList.append(imageOne.image!)
        tempImageList.append(imageTwo.image!)
        tempImageList.append(imageThree.image!)
        tempImageList.append(imageFour.image!)
        
        var imageList: [UIImage] = []
        for im in tempImageList {
            if im != UIImage(named: "cameraMask") {
                imageList.append(im)
            }
        }
        
        
        print("NAME: \(itemName.text)")
        print("COVER PHOTO: \(coverPhoto.image)")
        print("IMAGES: \(imageOne.image), \(imageTwo.image), \(imageThree.image), \(imageFour.image)")
        print("NEGOTIABLE: \(isNegotiable)")
        print("PRICE: \(itemPrice)")
        print("NEW: \(isNew)")
        print("DESCRIPTION: \(itemDescription.text)")
        print("LATITUDE: \(latitude)")
        print("LONGITUDE: \(longitude)")
        print("CITY: \(city)")
        
        let toPost = Post.createPost(images: imageList, name: itemName.text, seller: PFUser.current()!, itemDescription: itemDescription.text, price: itemPrice, conditionNew: isNew, negotiable: isNegotiable, sold: false, city: city!, latitude: latitude!, longitude: longitude!)
        
        let marketsToPost = ["UCI Free and For Sale": "Books"]
        
        toPost.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
            if success {
                for (market, category) in marketsToPost {
                    toPost.parseObject.fetchIfNeededInBackground(block: { (post, error) in
                        if let post = post {
                            print("just fetched: \(post)")
                            let newPost = Post(post)
                            print("about to post to market!")
                            print("post id: \(newPost.parseObject.objectId)")
                            MarketPost.postItem(post: newPost, marketName: market, category: category)
                            print("Posted to market!")
                        }
                    })
                }
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
