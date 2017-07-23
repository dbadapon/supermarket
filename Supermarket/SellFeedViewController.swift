//
//  SellFeedViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/19/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse

class SellFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedView: UIView!
    
    @IBOutlet weak var lineViewOne: UIView!
    @IBOutlet weak var lineViewTwo: UIView!
    
    @IBOutlet weak var postTableView: UITableView!
    var posts: [Post]? = []
    var sellingPosts: [Post]? = []
    var soldPosts: [Post]? = []
    
    var items : [String] = ["Selling", "Sold"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.dataSource = self
        postTableView.delegate = self
        postTableView.separatorStyle = .singleLine
        
        lineViewOne.backgroundColor = UIColor.white
        lineViewTwo.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        definesPresentationContext = true
        
        segmentedControl.tintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        segmentedControl.layer.masksToBounds = true
        
        segmentedControl.tintColor = UIColor.clear
        
        // segmentedView.addTarget(self, action: #selector(SellFeedViewController.segmentedViewControllerValueChanged(_:)), for: .valueChanged)

        segmentedView.backgroundColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : UIColor.white,
            NSFontAttributeName as NSObject: UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
            ]
        segmentedControl.setTitleTextAttributes(boldTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(boldTextAttributes, for: .normal)
        
        var query = PFQuery(className: "Post")
        query.whereKey("sold", equalTo: false)
        // query.whereKey("seller", equalTo: PFUser.current())
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                print (posts.count)
                print ("IT FOUND POSTS")
                for item in posts {
                    let post = Post(item)
                    self.sellingPosts!.append(post)
                }
                
                self.posts = self.sellingPosts
                self.postTableView.reloadData()
            } else if error != nil {
                print (error?.localizedDescription)
            } else {
                print ("the posts could not be loaded into the sell feed")
            }
            
        }
        
        var secondQuery = PFQuery(className: "Post")
        secondQuery.whereKey("sold", equalTo: true)
        // query.whereKey("seller", equalTo: PFUser.current())
        secondQuery.limit = 20
        
        secondQuery.findObjectsInBackground { (posts, error) in
            if let posts = posts {
                print (posts.count)
                print ("IT FOUND POSTS")
                for item in posts {
                    let post = Post(item)
                    self.soldPosts!.append(post)
                }
                
                self.posts = self.sellingPosts
                self.postTableView.reloadData()
            } else if error != nil {
                print (error?.localizedDescription)
            } else {
                print ("the posts could not be loaded into the sell feed")
            }
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postTableView.dequeueReusableCell(withIdentifier: "SellFeedCell", for: indexPath) as! SellFeedCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.post = posts![indexPath.row]
        
        return cell
    }
    
    func segmentedViewControllerValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func segmentDidChange(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.posts = sellingPosts
            lineViewOne.backgroundColor = UIColor.white
            lineViewTwo.backgroundColor = UIColor.clear
        } else {
            self.posts = soldPosts
            lineViewOne.backgroundColor = UIColor.clear
            lineViewTwo.backgroundColor = UIColor.white
        }
        
        self.postTableView.reloadData()
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
