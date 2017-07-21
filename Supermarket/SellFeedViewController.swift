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
    
    @IBOutlet weak var postTableView: UITableView!
    var posts: [Post]? = []
    var sellingPosts: [Post]? = []
    var soldPosts: [Post]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        definesPresentationContext = true
        
        
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
        
        cell.post = posts![indexPath.row]
        
        return cell
    }
    
    @IBAction func segmentDidChange(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.posts = sellingPosts
        } else {
            self.posts = soldPosts
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
