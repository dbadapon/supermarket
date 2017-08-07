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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newMark: UIImageView!
    @IBOutlet weak var interestedButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change the navigation bar
        self.navigationItem.title = "Item Details"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!, NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.isTranslucent = false
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        
        
        let postSellerUsername = post.seller!.objectId
        let currentUsername = PFUser.current()!.objectId
        print (postSellerUsername)
        print (currentUsername)
        print("Has the item been sold? \(post.sold)")
        if postSellerUsername == currentUsername {
            // keep interested button lol
        } else if post.sold! == false {
            soldButton.setTitle("Message Seller", for: .normal)
        }
        
        if post.sold! {
            print("sold...")
            soldButton.frame.size.height = 0
            soldButton.frame.size.width = 0
            soldButton.alpha = 0
            soldButton.isEnabled = false
            // doesn't show up for sold posts
        }
        
        
        
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
            self.timeLabel.text = "Posted on \(createdAtString)"
        }
        
        if let description = post.itemDescription {
            self.descriptionLabel.text = description
        }
        
        if let interestedList = post.parseObject["interested"] as? [String] {
            if interestedList.contains((PFUser.current()?.username)!) {
                interestedButton.isSelected = true
            } else {
                interestedButton.isSelected = false
                // maybe get rid of this idk lol
            }
        }
        
        if post.conditionNew! {
            newMark.isHidden = false
        } else {
            newMark.isHidden = true
        }
        self.carouselView.bringSubview(toFront: newMark)
        
        // Set map
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(post.latitude!), longitude: CLLocationDegrees(post.longitude!))
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!]
//        navigationController?.navigationBar.barTintColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
//        navigationController?.navigationBar.barStyle = UIBarStyle.black
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.isTranslucent = false
//        automaticallyAdjustsScrollViewInsets = false
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Item Details"
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMessage(_ sender: Any) {
        if post.seller == PFUser.current() {
            // do things as though this post was created by this user
            
            
            
            
        } else {
            // do things as if this is some other user's post
            
            
            
            
            
            
        }
    }
    
    @IBAction func onSold(_ sender: Any) {
        // this is only if you're coming from the sell feed...
        
        post.seller?.fetchIfNeededInBackground(block: { (user, error) in
            if let user = user {
                let username = user["username"] as! String
                if PFUser.current()?.username == username {
                    if let interestedList = self.post.interested {
                        print (interestedList)
                        let query: PFQuery = PFUser.query()!
                        query.whereKey("username", containedIn: interestedList)
                        query.findObjectsInBackground(block: { (users, error) in
                            if let error = error {
                                print ("There was a problem with finding the user \(error.localizedDescription)")
                            } else {
                                if let users = users {
                                    print ("there were \(users.count) users")
                                    for user in users {
                                        let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: user as! PFUser, withMessage: "The \(self.post.name!) that you were interested in has been sold!", withPostObject: self.post.parseObject)
                                    }
                                }
                                
                            }
                        })
                        
                    }
                    
                    self.post.sold = true
                    self.post.parseObject.saveInBackground { (success, error) in
                        if let error = error {
                            print ("problem changing to sold \(error.localizedDescription)")
                        } else if success {
                            print ("Success with changing to sold")
                        } else {
                            print ("I'm not sure what happened with changing it to sold")
                        }
                    }
                }
                else { // we're on the buy
                    print("Notify the seller!")
                    let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: self.post.seller!, withMessage: " wants to ask about your ", withPostObject: self.post.parseObject)
                }

            } else {
                print("Error fetching user/username: \(error?.localizedDescription)")
            }
        })

    }
    
    @IBAction func onInterested(_ sender: Any) {
        interestedButton.isSelected = true
        let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: post.seller!, withMessage: " is interested in your ", withPostObject: post.parseObject)
        
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
