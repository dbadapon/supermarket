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
import YNDropDownMenu

class BuyFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ModalDelegate, YNDropDownDelegate {
    
    func hideMenu() {
        print ("hey")
    }
    
    func changeMenu(title: String, at index: Int) {
        print (title)
    }
    
    func changeMenu(title: String, status: YNStatus, at index: Int) {
        print (title)
    }
    
    func changeView(view: UIView, at index: Int) {
        print (index)
    }
    
    func alwaysSelected(at index: Int) {
        print (index)
    }
    
    func normalSelected(at index: Int) {
        print (index)
    }
    
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var filterDropDownView: UIView!
    @IBOutlet weak var categoryDropDownView: UIView!
    
    @IBOutlet weak var postTableView: UITableView!
    var filterTableView: UITableView?
    var categoryTableView: UITableView?
    var dropView: YNDropDownMenu?
    
    var searchController: UISearchController!
    
    var posts: [Post] = []
    
    var markets: [Market] = []
    
    var currentMarket: Market?
    let ourColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
    
    func changedMarket(market: Market) {
        self.currentMarket = market
        self.navigationItem.title = self.currentMarket!.name
        loadPosts()
        self.postTableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        
        // create Rice market; comment out after running once
        
        // let categories: [String: [PFObject]]? = ["Books": [], "Kitchen": [], "Home": [], "Clothing": [], "Electronics": [], "Supplies": []]
        
        /*
        let yaleTextbookExchangeMarket = Market.createMarket(profileImage: #imageLiteral(resourceName: "yale_circle_logo.jpg"), withName: "Yale Textbook Exchange", withDescription: "Buy, sell, and exchange textbooks with other Yalies", withCategories: ["Anthropology", "Archaeology", "Architecture", "Art & Art History", "Astronomy", "Biology", "Biomedical Engineering", "Chemical Engineering", "Chemistry", "Cognitive Science", "Computer Science", "Computing and the Arts", "East Asian Studies", "East European Studies", "Economics", "Electrical Engineering", "English", "Environmental Science", "Film and Media Studies", "French", "Geology & Geophysics", "German Studies", "Global Affairs", "History", "Humanities", "Italian", "Judaic Studies", "Latin American Studies", "Linguistics", "Literature", "Mathematics", "Mechanical Engineering", "Music", "Neuroscience", "Philosophy", "Physics", "Political Science", "Portuguese", "Psychology", "Religious Studies", "Russian", "Sociology", "South Asian Studies", "Spanish", "Statistics and Data", "Theater Studies"], withLatitude: 41.3163244, withLongitude: -72.92234309999998) { (success, error) in
            if success {
                print(success)
            } else {
                print("Error with yaleTextbookExchangeMarket")
            }
        }

        let uciSchoolSuppliesMarket = Market.createMarket(profileImage: #imageLiteral(resourceName: "uci_circle_logo.png"), withName: "UCI Office/Desk Supplies", withDescription: "Have extra school supplies? Need school supplies? Sell and buy them here!", withCategories: ["Agendas", "Binders", "Colored Pencils", "Envelopes", "Highlighters", "Index Cards", "Markers", "Notebooks", "Paper/Binder Clips", "Pencils", "Pens", "Rubberbands", "Scissors", "Staplers/Staples", "Sticky Notes", "Tape", "USBs"], withLatitude: 33.6404952, withLongitude: -117.8442962) { (success, error) in
            if success {
                print(success)
            } else {
                print("Error with uciSchoolSuppliesMarket")
            }
        }
        
        let riceUndergraduatesMarket = Market.createMarket(profileImage: #imageLiteral(resourceName: "rice_circle_logo.png"), withName: "Rice Undergraduate Students", withDescription: "Free and for sale dorm items", withCategories: ["Bedding", "Chairs", "Clothing", "Decorations", "Desks", "Electronics", "Fans", "Food/Snacks", "Household", "Kitchen Utensils", "Lamps", "Laundry", "Lights", "Microwaves", "Refrigerators", "School Supplies", "Shoes", "Speakers", "Storage", "Toiletries"], withLatitude: 29.7173941, withLongitude: -95.4018312) { (success, error) in
            if success {
                print(success)
            } else {
                print("Error with riceUndergraduatesMarket")
            }
        }
 */
        
        
        // creating dummy posts
        
//        let image = UIImage(named: "accounting textbook")!
//
//        let post1 = Post.createPost(images: [image], name: "Intermediate Accounting 13th Ed.", seller: PFUser.current()!, itemDescription: "For Accounting 122a.", price: 15.00, conditionNew: false, negotiable: true, sold: false, city: "Irvine, CA", latitude: 33.640495, longitude: -117.844296)
//
//
//        let marketsToPost = ["UCI Free and For Sale": "Books"]
//
//        post1.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
//            if success {
//                for (market, category) in marketsToPost {
//                    post1.parseObject.fetchIfNeededInBackground(block: { (post, error) in
//                        if let post = post {
//                            print("just fetched: \(post)")
//                            let newPost = Post(post)
//                            MarketPost.postItem(post: newPost, marketName: market, category: category)
//                        }
//                    })
//                }
//            }
//        }
        
        
        
//        let image2 = UIImage(named: "rice cooker")!
//
//        let post2 = Post.createPost(images: [image2], name: "Rice cooker", seller: PFUser.current()!, itemDescription: "Medium-sized, perfect for college dorms!", price: 20.00, conditionNew: false, negotiable: false, sold: false, city: "New Haven, CT", latitude: 41.3163, longitude: 72.9223)
//
//        let marketsToPost = ["UCI Free and For Sale": "Kitchen", "Yale Class of 2020": "Kitchen"]
//
//        post2.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
//            if success {
//                for (market, category) in marketsToPost {
//                    post2.parseObject.fetchIfNeededInBackground(block: { (post, error) in
//                        if let post = post {
//                            print("just fetched: \(post)")
//                            let newPost = Post(post)
//                            MarketPost.postItem(post: newPost, marketName: market, category: category)
//                        }
//                    })
//                }
//            }
//        }
        
        
        
//        let image3 = UIImage(named: "brita")!
//
//        let post3 = Post.createPost(images: [image3], name: "Brita Filter", seller: PFUser.current()!, itemDescription: "Drinking water for dayz! New and unused.", price: 12.75, conditionNew: true, negotiable: false, sold: false, city: "Houston, TX", latitude: 41.3163, longitude: 72.9223)
//
//        let marketsToPost = ["UCI Free and For Sale": "Kitchen", "Yale Class of 2020": "Kitchen", "Rice Undergrads": "Kitchen"]
//
//        post3.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
//            if success {
//                for (market, category) in marketsToPost {
//                    post3.parseObject.fetchIfNeededInBackground(block: { (post, error) in
//                        if let post = post {
//                            print("just fetched: \(post)")
//                            let newPost = Post(post)
//                            MarketPost.postItem(post: newPost, marketName: market, category: category)
//                        }
//                    })
//                }
//            }
//        }
        
        
        
//        let image4 = UIImage(named: "understanding video games")!
//
//        let post4 = Post.createPost(images: [image4], name: "Understanding Video Games: The Essential Introduction", seller: PFUser.current()!, itemDescription: "For Nikki Crenshaw's ICS 60.", price: 20.00, conditionNew: false, negotiable: true, sold: false, city: "Irvine, CA", latitude: 33.640495, longitude: -117.844296)
//
//
//
//        let marketsToPost = ["UCI Free and For Sale": "Books"]
//
//        post4.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
//            if success {
//                for (market, category) in marketsToPost {
//                    post4.parseObject.fetchIfNeededInBackground(block: { (post, error) in
//                        if let post = post {
//                            print("just fetched: \(post)")
//                            let newPost = Post(post)
//                            print("about to post to market!")
//                            print("post id: \(newPost.parseObject.objectId)")
//                            MarketPost.postItem(post: newPost, marketName: market, category: category)
//                            print("Posted to market!")
//                        }
//                    })
//                }
//            }
//        }
        
        
        
        
//         YOU'RE GONNA HAVE TO CHANGE ALL THIS SEARCH STUFF...FIGURE OUT HOW TO DO IT!
        
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        
//        postTableView.tableHeaderView = searchController.searchBar
//        
//        searchController.searchBar.barTintColor = UIColor.white
//        
//        searchController.searchBar.layer.borderWidth = 1
//        
//        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        
        // searchController.searchBar.clipsToBounds = true
        
        definesPresentationContext = true
        
        
        var dropDownViews: [UIView] = []
        let frame1 = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 200)
        filterTableView = UITableView(frame: frame1)
        categoryTableView = UITableView(frame: frame1)
       
        
        dropDownViews.append(filterTableView!)
        dropDownViews.append(categoryTableView!)
        
        filterTableView!.delegate = self
        filterTableView!.dataSource = self
        categoryTableView!.delegate = self
        categoryTableView!.dataSource = self
        
        let frame = CGRect(x: 0, y: 0, width: dropDownView.frame.width, height: dropDownView.frame.height)
        
        dropView = YNDropDownMenu(frame:frame, dropDownViews: dropDownViews, dropDownViewTitles: ["Filter by", "Categories"])
        self.view.addSubview(dropView!)
        dropView?.setLabelColorWhen(normal: UIColor.black, selected: ourColor, disabled: UIColor.gray)
        

//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
        setFirstMarket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func setFirstMarket() {
        let query = PFQuery(className: "Market")
        query.addAscendingOrder("name")
        
        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
            if let markets = markets {
                for m in markets {
                    let market = Market(m)
                    self.markets.append(market)
                }
                self.currentMarket = self.markets[0]
                let marketName = self.currentMarket?.name
                self.navigationItem.title = marketName
                self.loadPosts()
                
                self.postTableView.reloadData()
                self.filterTableView!.reloadData()
                self.categoryTableView!.reloadData()
            }
            else {
                print("Error getting markets: \(error?.localizedDescription)")
            }
        }
    }
    
    func loadPosts() {
        let query = PFQuery(className: "MarketPost")
        query.addDescendingOrder("createdAt")
        query.whereKey("market", equalTo: currentMarket?.name)
        self.posts = []
        
        query.findObjectsInBackground { (marketPosts, error) in
            if let marketPosts = marketPosts {
                var idArray: [String] = []
                for m in marketPosts {
                    let marketPost = MarketPost(m)
                    let postID = marketPost.post
                    idArray.append(postID!)
                }
                let postQuery = PFQuery(className: "Post")
                postQuery.addDescendingOrder("createdAt")
                postQuery.whereKey("objectId", containedIn: idArray)
                postQuery.findObjectsInBackground(block: { (posts, error) in
                    if let posts = posts {
                        for p in posts {
                            let post = Post(p)
                            if post.sold == false {
                                self.posts.append(post)
                            }
                        }
                        print("posts: \(self.posts)")
//                        print("first post: \(self.posts[0].parseObject)")
                        self.postTableView.reloadData()
                    } else {
                        print("Error fetching Posts: \(error?.localizedDescription)")
                    }
                })
            } else {
                print("Error fetching MarketPosts: \(error?.localizedDescription)")
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == postTableView {
            return posts.count
        } else if tableView == filterTableView {
            print ("got here")
            return 3
        } else {
            print ("hey hey hey")
            print (currentMarket!)
            print (currentMarket!.categories)
            print (currentMarket!.categories.count)
            return currentMarket!.categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == postTableView {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
        
        
//        let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
        
        let post = posts[indexPath.row]
        let parseObject = post.parseObject
        
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
        
            return cell
        } else if tableView == filterTableView {
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            var cell = CustomCell(frame: frame, title: "hey")
            if indexPath.row == 0{
                cell.cellLabel.text = "Price up"
            } else if indexPath.row == 1 {
                cell.cellLabel.text = "Price down"
            } else {
                cell.cellLabel.text = "Most recent"
            }
            
            return cell
        } else {
            
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            var cell = CustomCell(frame: frame, title: "just testing this out")
            cell.cellLabel.text = currentMarket!.categories[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == postTableView {
            postTableView.deselectRow(at: indexPath, animated: true)
        }
        else if tableView == filterTableView {
            filterTableView?.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0 {
                print ("filter by price up")
            } else if indexPath.row == 1 {
                print ("filter by price down")
            } else {
                print ("filter by when it was made")
            }
            dropView?.hideMenu()
        } else {
            categoryTableView?.deselectRow(at: indexPath, animated: true)
            print ("the new category is \(currentMarket!.categories[indexPath.row])")
            dropView?.hideMenu()
        }
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
    
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
            let destination = segue.destination as! UINavigationController
            let destinationVC = destination.topViewController as! SidebarViewController
            destinationVC.delegate = self
        }
    }
}
