//
//  DetailViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var post: PFObject!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        
        // make navigation bar clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        automaticallyAdjustsScrollViewInsets = false
        
//        tableView.reloadData()
        
//        let post = Post.postItem(images: nil, name: "Foldable Chair", itemDescription: "This is a cool foldable chair. Pretty cool", price: 10.00, conditionNew: true, negotiable: true, latitude: 30, longitude: 30)
//        
//        print (post)
//        print (post?["name"])
//        
//        
//        Market.postToMarkets(destinations: ["Rice Students": ["English", "Math"], "Yale Students": ["History"], "UC Irvine Students": ["Science"]], post: post!)
        
//        let query = PFQuery(className: "Post")
//        
//        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
//            if let error = error {
//                print (error.localizedDescription)
//            } else {
//                for post in posts! {
//                    print (post["name"])
//                }
//            }
//        }
        
//        let query = PFQuery(className: "Market")
//        query.whereKey("name", equalTo: "Rice Students")
//        
//        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
//            if let error = error {
//                print (error.localizedDescription)
//            } else {
//                for market in markets! {
//                    
//                    let categories = market["categories"] as! [String: Any]
//                    let category = categories["English"] as! [PFObject]
//                    let post = category[0] as! PFObject
//                    post.fetchInBackground(block: { (post: PFObject?, error: Error?) in
//                        if let error = error {
//                            print (error.localizedDescription)
//                        } else {
//                            print (post!["name"])
//                        }
//                    })
//                    
//                    
//                }
//            }
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPictureCell") as! DetailPictureCell
            
            cell.postImage = post
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailInformationCell") as! DetailInformationCell
            
            let name = post["name"] as! String
            cell.nameLabel.text = name
            
            let price = post["price"] as! Double
            cell.priceLabel.text = "$\(price)"
            
            let new = post["conditionNew"] as! Bool
            var conditionString = ""
            if new {
                conditionString = "New"
            }
            cell.conditionLabel.text = conditionString
            
            let latitude = post["latitude"] as! Double
            let longitude = post["longitude"] as! Double
            cell.locationLabel.text = "Lat: \(latitude), Long: \(longitude)"
            
            let timestamp = post["_created_at"] as? String
            // maybe change this to a var so you can format it...
            cell.timestampLabel.text = timestamp
            
            let description = post["itemDescription"] as! String
            cell.descriptionLabel.text = description
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
