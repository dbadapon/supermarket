//
//  DetailViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.reloadData()
        
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
        
        let query = PFQuery(className: "Market")
        query.whereKey("name", equalTo: "Rice Students")
        
        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                for market in markets! {
                    
                    let categories = market["categories"] as! [String: Any]
                    let category = categories["English"] as! [PFObject]
                    let post = category[0] as! PFObject
                    post.fetchInBackground(block: { (post: PFObject?, error: Error?) in
                        if let error = error {
                            print (error.localizedDescription)
                        } else {
                            print (post!["name"])
                        }
                    })
                    
                    
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPictureCell") as! DetailPictureCell
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailInformationCell") as! DetailInformationCell
            
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
