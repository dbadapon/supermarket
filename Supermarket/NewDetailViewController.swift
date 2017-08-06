//
//  NewDetailViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 8/4/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit
import ZKCarousel

class NewDetailViewController: ViewController {

    var allImages: [UIImage] = []
    var post: Post = Post()
    
    @IBOutlet weak var carouselView: ZKCarousel!
    @IBOutlet weak var interestedCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup carousel view
        let images = post.images
        var actualImages: [UIImage] = []
        for image in images! {
            image.getDataInBackground(block: { (data, error) in
                if let error = error {
                    print (error.localizedDescription)
                } else if let data = data {
                    // print ("it got one image")
                    let actualImage = UIImage(data: data)
                    if actualImage != nil {
                        actualImages.append(actualImage!)
                    }
                } else {
                    // print ("could not load the image")
                }
                if actualImages.count == images?.count {
                    // print ("got all the pictures")
                    var slides: [ZKCarouselSlide] = []
                    for item in actualImages {
                        let slide = ZKCarouselSlide(image: item, title: "", description: "")
                        slides.append(slide)
                    }
                    self.carouselView.slides = slides
                    self.carouselView.pageControl.numberOfPages = slides.count
                    self.carouselView.pageControl.currentPageIndicatorTintColor = Constants.Colors.mainColor
                    self.carouselView.pageControl.pageIndicatorTintColor = UIColor.white
                }
            })
        }
        
        if let name = post.name {
            self.nameLabel.text = name
        }
        
        if let price = post.price {
            self.priceLabel.text = "$" + String(describing: price)
        }
        
        if post.conditionNew != nil && post.conditionNew! {
            self.conditionLabel.text = "New"
        } else {
            self.conditionLabel.text = ""
        }
        
        if let city = post.city {
            self.cityLabel.text = city
        }
        
        let time = post.parseObject.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Configure output format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        var createdAtString = ""
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        if let time = time {
            createdAtString = formatter.string(from: time)
            self.timeLabel.text = createdAtString
        }
        
        if let description = post.itemDescription {
            self.descriptionLabel.text = description
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMessage(_ sender: Any) {
    }
    
    @IBAction func onInterested(_ sender: Any) {
        // interestedButton.isSelected = true
        let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: PFUser.current()!, withMessage: " is interested in your ", withPostObject: post.parseObject)
        
        let interested = post.parseObject["interested"] as? [String]
        if let interested = interested {
            var newInterested: [String] = []
            for username in interested {
                newInterested.append(username)
            }
            newInterested.append((PFUser.current()?.username)!)
            post.parseObject["interested"] = newInterested
        } else {
            let newInterested = [PFUser.current()?.username]
            post.parseObject["interested"] = newInterested
        }
        
        post.parseObject.saveInBackground { (success, error) in
            if let error = error {
                print ("there was an error with updating the interested array \(error.localizedDescription)")
            } else {
                print ("the interested array should have been updated correctly")
            }
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
