//
//  BuyFeedViewController.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BuyFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    
    @IBOutlet weak var postTableView: UITableView!
    
    var searchController: UISearchController!
    
    var posts: [PFObject] = []
    
    var allPosts: [PFObject] = []
    
    var markets: [PFObject] = []
    
    var currentMarket: PFObject?
    

    
    
    // try showing all posts for now, then figure out how to show all posts only from the selected market...
    

    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.dataSource = self
        postTableView.delegate = self
        
        let image = UIImage(named: "accounting textbook")!
        
        
//        let post = Post.postItem(images: [image], name: "Intermediate Accounting 13th Ed.", itemDescription: "For Accounting 122a.", price: 15.00, conditionNew: false, negotiable: true, latitude: 33.640495, longitude: -117.844296)
    

//        Post.postItem(images: <#T##[UIImage]?#>, name: <#T##String#>, itemDescription: <#T##String#>, price: <#T##Double#>, conditionNew: <#T##Bool#>, negotiable: <#T##Bool#>, latitude: <#T##Double#>, longitude: <#T##Double#>)
        
//        Post.postItem(images: [image], name: "Brita filter", itemDescription: "New and unused! Fresh drinking water for days.", price: 12.25, conditionNew: true, negotiable: false, latitude: 33.640495, longitude: -117.844296)
        
        
        // Books, Kitchen, Home, Clothing, Electronics, Supplies
        
//        let categories: [String: [Post]?]? = ["Books": [], "Kitchen": [], "Home": [], "Clothing": [], "Electronics": [], "Supplies": []]
//        
//        Market.postMarket(withName: "UCI Free and For Sale", withCategories: categories, withNewCategory: false, withPublic: true, withLatitude: 33.640495, withLongitude: -117.844296) { (success, error) in
//            if success {
//                print("created new market yay!")
//            } else {
//                print(error?.localizedDescription)
//            }
//        }
        
        let marketsToPost: [String: [String]] = ["UCI Free and For Sale": ["Books"]]
        
        
//        Market.postToMarkets(destinations: marketsToPost, post: post!)
        
        
        
        
        
        // YOU'RE GONNA HAVE TO CHANGE ALL THIS SEARCH STUFF...FIGURE OUT HOW TO DO IT!

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        postTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.barTintColor = UIColor.white
        
        searchController.searchBar.layer.borderWidth = 1
        
        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        
        searchController.searchBar.clipsToBounds = true
        
        definesPresentationContext = true
        

//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
        setFirstMarket()
        print(markets)

//        currentMarket = self.markets[0]
//        let marketName = currentMarket!["name"] as! String
//        self.title = marketName
        
        queryParse()
//        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
//        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
//        self.navigationController.view.backgroundColor = [UIColor whiteColor]
        
        navigationController?.view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setFirstMarket() {
        let query = PFQuery(className: "Market")
//        query.addAscendingOrder("name")
        query.addAscendingOrder("name")
        
        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
            if let markets = markets {
                self.markets = markets
                print("Just set markets to: \(markets)")
                self.currentMarket = self.markets[2]
                let marketName = self.currentMarket!["name"] as! String
                self.navigationItem.title = marketName
//                self.loadPosts()
//                self.marketTableView.reloadData()
            }
            else {
                print("Error getting markets: \(error?.localizedDescription)")
            }
        }
        
    }
    
    func loadPosts() {
//        let query = PFQuery(className: "Post")
        var posts: [Post] = []
        let categories = currentMarket!["categories"] as! [String: [Post]]
        for (key, value) in categories {
            for post in value {
                posts.append(post)
            }
        }
//        query.whereKey("id", containedIn: postIDs)
    }
    
    func queryParse() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
//        query.limit = 20
        //includekey stuff... do you need that?
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.postTableView.reloadData()
            }
            else {
                print("Error loading posts: \(error?.localizedDescription)")
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
        
        
//        let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
        
        let post = posts[indexPath.row]
        cell.itemImage = post
        
        let name = post["name"] as! String
        cell.nameLabel.text = name
    
        
        let category = "Category"
        cell.categoryLabel.text = category
        
        let price = post["price"]!
        cell.priceLabel.text = "$\(price)"
        
//        let negotiable = post["negotiable"] as! Bool
//        var negotiableString = ""
//        
//        if negotiable {
//            negotiableString = "Negotiable"
//        }
//        cell.negotiableLabel.text = negotiableString
        
        let conditionNew = post["conditionNew"] as! Bool
        var newString = ""
        if conditionNew {
            newString = "New"
        }
        cell.conditionLabel.text = newString
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // clear back button text
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let cell = sender as! UITableViewCell
        if let indexPath = postTableView.indexPath(for: cell) {
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = post
        }
    }
 

}
