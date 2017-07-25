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
//import SideMenu



class BuyFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, ModalDelegate {

    
    @IBOutlet weak var postTableView: UITableView!
    
    var searchController: UISearchController!
    
    var posts: [Post] = []
    
//    var allPosts: [PFObject] = []
    
    var markets: [Market] = []
    
    var currentMarket: Market?
    
//    var sideMenuNC: UISideMenuNavigationController?
    
    
    
    func changedMarket(market: Market) {
        self.currentMarket = market
        self.navigationItem.title = self.currentMarket!.name
        print("current market is now: \(currentMarket)")
        loadPosts()
//        showSelling()
        self.postTableView.reloadData()
//        print("CURRENT MARKET IS NOW: \(currentMarket["name"])")
    }
    
    
    
    
    // try showing all posts for now, then figure out how to show all posts only from the selected market...
    

    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.dataSource = self
        postTableView.delegate = self
        
        
        // create Rice market; comment out after running once
        
        let categories: [String: [PFObject]]? = ["Books": [], "Kitchen": [], "Home": [], "Clothing": [], "Electronics": [], "Supplies": []]
        
//
//        Market.postMarket(withName: "Rice Undergrads", withDescription: "A marketplace for all undergraduates at Rice University!", withCategories: categories!,  withLatitude: 29.7174, withLongitude: 95.4018) { (success, error) in
//            if success {
//                print("Created new market!")
//            } else {
//                print("Error posting market: \(error?.localizedDescription)")
//            }
//        }
        
        
        // creating dummy posts
        
//        let image = UIImage(named: "accounting textbook")!
//
//        let post1 = Post.createPost(images: [image], name: "Intermediate Accounting 13th Ed.", itemDescription: "For Accounting 122a.", price: 15.00, conditionNew: false, negotiable: true, sold: false, latitude: 33.640495, longitude: -117.844296)
//
//
//        MarketPost.postItem(post: post1, marketName: "UCI Free and For Sale", category: "Books")
        
        
        
//        let image2 = UIImage(named: "rice cooker")!
//
//        let post2 = Post.createPost(images: [image2], name: "Rice cooker", itemDescription: "Medium-sized, perfect for college dorms!", price: 20.00, conditionNew: false, negotiable: false, sold: false, latitude: 33.640495, longitude: -117.844296)
//
//        let marketsToPost = ["UCI Free and For Sale": "Kitchen", "Yale Class of 2020": "Kitchen"]
//
//        for (market, category) in marketsToPost {
//            MarketPost.postItem(post: post2, marketName: market, category: category)
//        }
        
        
        
//        let image3 = UIImage(named: "brita")!
//
//        let post3 = Post.createPost(images: [image3], name: "Brita Filter", itemDescription: "Drinking water for dayz! New and unused.", price: 12.75, conditionNew: true, negotiable: false, sold: false, latitude: 41.3163, longitude: 72.9223)
//
//        let marketsToPost = ["UCI Free and For Sale": "Kitchen", "Yale Class of 2020": "Kitchen", "Rice Undergrads": "Kitchen"]
//
//        for (market, category) in marketsToPost {
//            MarketPost.postItem(post: post3, marketName: market, category: category)
//        }
        
        
        
        
        
        
//         YOU'RE GONNA HAVE TO CHANGE ALL THIS SEARCH STUFF...FIGURE OUT HOW TO DO IT!
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        postTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.barTintColor = UIColor.white
        
        searchController.searchBar.layer.borderWidth = 1
        
        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        
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
        
//        queryParse()
//        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("IN VIEW WILL APPEAR")
//        posts = []
//        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
//        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
//        self.navigationController.view.backgroundColor = [UIColor whiteColor]
        
//        navigationController?.view.backgroundColor = UIColor.white
//
//        navigationController?.navigationBar.tintColor = UIColor.white
//
//        navigationController?.navigationBar.isTranslucent = false
        
//        loadPosts()
//        postTableView.reloadData()
    }
    
    
    func setFirstMarket() {
        let query = PFQuery(className: "Market")
//        query.addAscendingOrder("name")
        query.addAscendingOrder("name")
        
        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
            if let markets = markets {
                for m in markets {
                    let market = Market(m)
                    self.markets.append(market)
                }
//                self.markets = markets
//                print("Just set markets to: \(markets)")
                self.currentMarket = self.markets[0]
                let marketName = self.currentMarket?.name
                self.navigationItem.title = marketName
                self.loadPosts()
//                self.showSelling()
//                print(self.posts)
                self.postTableView.reloadData()
            }
            else {
                print("Error getting markets: \(error?.localizedDescription)")
            }
        }
    }
    
    func loadPosts() {
        let query = PFQuery(className: "Post")
//        query.whereKey
        var posts: [Post] = []
        print("current market is: \(currentMarket)")
        let categories = currentMarket!.categories
        
        
        self.posts = []
        
//        query.findObjectsInBackground { (posts, error) in
//            if let posts = posts {
//                for (key, value) in categories {
//                    for p in value! {
//
//                        let post = Post(p)
//                        if post.sold == false {
//                            self.posts.append(post)
//                        }
//                    }
//                }
//            }
//     }
        
//        for (key, value) in categories {
//            for p in value! {
//                let post = Post(p)
//                let parseObject = post.parseObject
//                parseObject.fetchIfNeededInBackground(block: { (parseObject, error) in
//                    if let parseObject = parseObject {
//                        // you have to fix this... it feels wrong lol
////                        let sold = parseObject["sold"] as! Bool
////                        self.posts = []
//                        if post.sold == false {
//                            self.posts.append(post)
////                            print("appended to local post array...")
//                            print(self.posts)
//                            self.postTableView.reloadData()
//                        }
//                    }
//                })
////                if post.sold! == false {
////                    posts.append(post)
////                }
//            }
//        }
////        self.posts = posts
////        print(self.posts)
////        self.postTableView.reloadData()
    }
    
    
    
    
//    func queryParse() {
//        let query = PFQuery(className: "Post")
//        query.addDescendingOrder("createdAt")
////        query.limit = 20
//        //includekey stuff... do you need that?
//        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
//            if let posts = posts {
//                self.posts = posts
//                self.postTableView.reloadData()
//                print("POSTS: \(self.posts)")
//            }
//            else {
//                print("Error loading posts: \(error?.localizedDescription)")
//            }
//        }
//        
//    }
    

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
        let parseObject = post.parseObject
        
        // maybe Post needs a fetchInBackground method so you don't have to do this...
        post.parseObject.fetchInBackground { (parseObject, error) in
            if let parseObject  = parseObject {
                cell.itemImage = parseObject
                
                let name = post.name
                cell.nameLabel.text = name
                
                
                let category = "Category"
                cell.categoryLabel.text = category
                
                let price = post.price!
                let formattedPrice = String(format: "%.2f", price)
                cell.priceLabel.text = "$\(formattedPrice)"
                
                
                let conditionNew = post.conditionNew!
                var newString = ""
                if conditionNew {
                    newString = "New"
                }
                cell.conditionLabel.text = newString
            } else {
                print(error?.localizedDescription)
            }
        }
        


        
//        post.fetchInBackground { (post, error) in
//            if let post = post {
//                cell.itemImage = post
//                
//                let name = post.name
//                cell.nameLabel.text = name
//                
//                
//                let category = "Category"
//                cell.categoryLabel.text = category
//                
//                let price = post.price
//                cell.priceLabel.text = "$\(price)"
//                
//                
//                let conditionNew = post.conditionNew
//                var newString = ""
//                if conditionNew {
//                    newString = "New"
//                }
//                cell.conditionLabel.text = newString
//            }
//            else {
//                print(error?.localizedDescription)
//            }
//        }
        

        
        
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
        
        if segue.identifier == "detailSegue" {
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
        
        
        if segue.identifier == "sideMenu" {
//            let sideMenuNC = segue.destination as! UISideMenuNavigationController
//            let sideMenuVC = sideMenuNC.root
//            let presentedVC = self.sideMenuVC
//            presentedVC!.delegate = self
//            print("side menu is: \(self.sideMenuVC)")
//            print("set the delegate!")
        
            let destination = segue.destination as! UINavigationController
            let destinationVC = destination.topViewController as! SidebarViewController
            print("destination VC: \(destinationVC)")
            destinationVC.delegate = self
        }
        
    }
 

}
