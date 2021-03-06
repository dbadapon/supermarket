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
import NVActivityIndicatorView
import TableViewReloadAnimation
import RAMAnimatedTabBarController

class BuyFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ModalDelegate, YNDropDownDelegate, NVActivityIndicatorViewable {
    
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
    var marketPosts: [PFObject] = []
    
    var searchController: UISearchController!
    var posts: [Post] = []
    var markets: [Market] = []
    var currentMarket: Market?
    var category: String = "All"
    var filter: String = "Most Recent"
    
    var refreshControl: UIRefreshControl!
    
    let ourColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)

    
    func changedMarket(market: Market) {
        self.category = "All"
        self.currentMarket = market
        self.navigationItem.title = self.currentMarket!.name
        // loadPosts()
        filterPosts()
        // self.postTableView.reloadData()
        
        // self.postTableView.reloadData(with: UITableView.AnimationType.simple(duration: 1, direction: .bottom(useCellsFrame: true), constantDelay: 0))
        
        // self.filterTableView?.reloadData()
        self.categoryTableView!.reloadData()
    }
    
    override func viewDidLoad() {
        // make sure tab bar is there
//        self.tabBarController?.tabBar.isHidden = false

        
        super.viewDidLoad()
        startAnimating(type: NVActivityIndicatorType.ballPulse, color: Constants.Colors.ourGray, backgroundColor: UIColor.clear)
        
        // pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        postTableView.insertSubview(refreshControl, at: 0)
        
        

        // add swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)

        postTableView.dataSource = self
        postTableView.delegate = self
        
        // apparently this throws it off
        
//        postTableView.rowHeight = UITableViewAutomaticDimension
//        // Provide an estimated row height. Used for calculating scroll indicator
//        postTableView.estimatedRowHeight = 250
//        postTableView.tableFooterView = UIView()
        
        
        // create Rice market; comment out after running once
        
        // let categories: [String: [PFObject]]? = ["Books": [], "Kitchen": [], "Home": [], "Clothing": [], "Electronics": [], "Supplies": []]
        
//        print("about to create market!")
//        Market.createMarket(profileImage: #imageLiteral(resourceName: "yale_circle_logo.jpg"), withName: "Yale Textbook Exchange", withDescription: "Buy, sell, and exchange textbooks with other Yalies", withCategories: ["Anthropology", "Archaeology", "Architecture", "Art & Art History", "Astronomy", "Biology", "Biomedical Engineering", "Chemical Engineering", "Chemistry", "Cognitive Science", "Computer Science", "Computing and the Arts", "East Asian Studies", "East European Studies", "Economics", "Electrical Engineering", "English", "Environmental Science", "Film and Media Studies", "French", "Geology & Geophysics", "German Studies", "Global Affairs", "History", "Humanities", "Italian", "Judaic Studies", "Latin American Studies", "Linguistics", "Literature", "Mathematics", "Mechanical Engineering", "Music", "Neuroscience", "Philosophy", "Physics", "Political Science", "Portuguese", "Psychology", "Religious Studies", "Russian", "Sociology", "South Asian Studies", "Spanish", "Statistics and Data", "Theater Studies"], withLatitude: 41.3163244, withCity: "New Haven, CT", withLongitude: -72.92234309999998) { (success, error) in
//            if success {
//                print("Successfully created market!")
//            } else {
//                print("Error with yaleTextbookExchangeMarket")
//            }
//        }
        
        
/*
        let uciSchoolSuppliesMarket = Market.createMarket(profileImage: #imageLiteral(resourceName: "uci_circle_logo.png"), withName: "UCI Office/Desk Supplies", withDescription: "Have extra school supplies? Need school supplies? Sell and buy them here!", withCategories: ["Agendas", "Binders", "Colored Pencils", "Envelopes", "Highlighters", "Index Cards", "Markers", "Notebooks", "Paper/Binder Clips", "Pencils", "Pens", "Rubberbands", "Scissors", "Staplers/Staples", "Sticky Notes", "Tape", "USBs"], withLatitude: 33.6404952, withCity: "Irvine, CA", withLongitude: -117.8442962) { (success, error) in
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
        
        
/*
        // YOU'RE GONNA HAVE TO CHANGE ALL THIS SEARCH STUFF...FIGURE OUT HOW TO DO IT!
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        postTableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
         
 */
        
        
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        // searchController.searchBar.clipsToBounds = true
        
        definesPresentationContext = true
        
        var dropDownViews: [UIView] = []
        let frame1 = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 135)
        let frame2 = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 250)
        filterTableView = UITableView(frame: frame1)
        categoryTableView = UITableView(frame: frame2)
       
        dropDownViews.append(filterTableView!)
        dropDownViews.append(categoryTableView!)
        
        filterTableView!.delegate = self
        filterTableView!.dataSource = self
        categoryTableView!.delegate = self
        categoryTableView!.dataSource = self
        
        let frame = CGRect(x: 0, y: 0, width: dropDownView.frame.width, height: dropDownView.frame.height)
        
        dropView = YNDropDownMenu(frame:frame, dropDownViews: dropDownViews, dropDownViewTitles: ["Filter by ", "Categories "])
        self.view.addSubview(dropView!)
        dropView?.setLabelColorWhen(normal: UIColor.black, selected: ourColor, disabled: UIColor.gray)
        let font2 = UIFont(name: "Avenir", size: 16)
        dropView?.setLabel(font: font2!)
        dropView?.bottomLine = UIView()
        dropView?.setImageWhen(normal: UIImage(named: "icons8-Expand Arrow-20"), selectedTintColor: Constants.Colors.mainColor, disabledTintColor: UIColor.black)


        // Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryParse), userInfo: nil, repeats: true)
        
        setFirstMarket()
    } // end of viewDidLoad
    
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        filterPosts()
    }
    
    
    // for swipe gestures
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("swiped right")
                performSegue(withIdentifier: "sideMenu", sender: self)
            case UISwipeGestureRecognizerDirection.down:
                print("swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("swiped up")
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(false)
        
        /*
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
         */
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!]
        navigationController?.navigationBar.barTintColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
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
                // self.loadPosts()
                self.filterPosts()
                
                self.postTableView.reloadData()
                self.filterTableView!.reloadData()
                self.categoryTableView!.reloadData()
            }
            else {
                print("Error getting markets: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func filterPosts() {
        startAnimating(type: NVActivityIndicatorType.ballPulse, color: Constants.Colors.ourGray, backgroundColor: UIColor.clear)
        
        self.posts = []
        let query = PFQuery(className: "MarketPost")
        query.whereKey("seller", notEqualTo: PFUser.current()?.username)
        query.whereKey("market", equalTo: currentMarket?.name!)
        
        if self.category != "All" {
            query.whereKey("category", equalTo: self.category)
        }
        
        query.findObjectsInBackground(block: { (marketPosts, error) in
            if let marketPosts = marketPosts {
                self.marketPosts = marketPosts
                var idArray: [String] = []
                for m in marketPosts {
                    let marketPost = MarketPost(m)
                    let postID = marketPost.post
                    idArray.append(postID!)
                }
                self.fetchFilteredPosts(idArray: idArray)
            } else {
                print("Error fetching MarketPost according to category: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func fetchFilteredPosts(idArray: [String]) {
        let postQuery = PFQuery(className: "Post")
        if self.filter == "Most Recent" {
            postQuery.addDescendingOrder("createdAt")
        } else if self.filter == "Price: Low to High" {
            postQuery.addAscendingOrder("price")
        } else if self.filter == "Price: High to Low" {
            postQuery.addDescendingOrder("price")
        }
        
        postQuery.whereKey("objectId", containedIn: idArray)
        postQuery.whereKey("sold", equalTo: false)
        postQuery.findObjectsInBackground { (posts, error) in
            if let posts = posts {
                for p in posts {
                    let post = Post(p)
                    self.posts.append(post)
                }
//                self.postTableView.reloadData()
//                self.postTableView.reloadData(with: UITableView.AnimationType.simple(duration: 0.75, direction: .top(useCellsFrame: true), constantDelay: 0))
                
                self.postTableView.reloadData(with: UITableView.AnimationType.simple(duration: 0.75, direction: .top(useCellsFrame: true), constantDelay: 0), reversed: false, completion: nil)

                // STOP ACTIVITY INDICATOR
                self.stopAnimating()
                self.refreshControl.endRefreshing()
            } else {
                print("Error fetching filtered posts: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    /*
    func loadPosts() { // SO YOU SHOULD JUST CALL FILTEREDPOSTS() EVERYWHERE INSTEAD OF LOADPOSTS TO AVOID REDUNDANT CODE
        let query = PFQuery(className: "MarketPost")
//        query.addDescendingOrder("createdAt")
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
                postQuery.whereKey("sold", equalTo: false)
                postQuery.findObjectsInBackground(block: { (posts, error) in
                    if let posts = posts {
                        for p in posts {
                            let post = Post(p)
//                            if post.sold == false {
//                                self.posts.append(post)
//                            }
                            self.posts.append(post)
                        }
//                        print("posts: \(self.posts)")
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
 */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == postTableView {
            return posts.count
        } else if tableView == filterTableView {
            // print ("got here")
            return 3
        } else {
            return currentMarket!.categories.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == postTableView && posts.count > 0 {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
            
//        let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
            
            // sow what if there are no posts there?
            
            let post = posts[indexPath.row]
            let parseObject = post.parseObject
            cell.itemImage = parseObject
            let price = post.price!
            let formattedPrice = String(format: "%.2f", price)
            cell.priceLabel.text = "$\(formattedPrice)"
            cell.nameLabel.text = post.name
            let conditionNew = post.conditionNew!
            
            cell.isNew = conditionNew
            
//            if conditionNew {
//                cell.conditionLabel.text = "New"
//            } else {
//                cell.conditionLabel.text = ""
//            }
//            cell.dateLabel.text = Post.getRelativeDate(date: parseObject.createdAt!)
            
        
//        post.parseObject.fetchInBackground { (parseObject, error) in
//            if let parseObject  = parseObject {
//                    cell.itemImage = parseObject
//
//                    let name = post.name
//                    cell.nameLabel.text = name
//
//
//                    let postId = parseObject.objectId as! String
//                    for marketpost in self.marketPosts {
//                        let id = marketpost["post"] as! String
//                        if id == postId {
//                            cell.categoryLabel.text = marketpost["category"] as! String
//                            break
//                        }
//                    }
//
//
//                    let price = post.price!
//                    let formattedPrice = String(format: "%.2f", price)
//                    cell.priceLabel.text = "$\(formattedPrice)"
//
//
//                    let conditionNew = post.conditionNew!
//                    var newString = ""
//                    if conditionNew {
//                        newString = "New"
//                    }
//                    cell.conditionLabel.text = newString
//                } else {
//                    print(error?.localizedDescription)
//                }
//            }
            
            return cell
        } else if tableView == filterTableView {
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            let cell = CustomCell(frame: frame, title: "hey")
            if indexPath.row == 0{
                cell.cellLabel.text = "Most Recent"
            } else if indexPath.row == 1 {
                cell.cellLabel.text = "Price: Low to High"
            } else {
                cell.cellLabel.text = "Price: High to Low"
            }
            
            return cell
        } else {
            
            let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            let cell = CustomCell(frame: frame, title: "just testing this out")
            if indexPath.row == 0 {
                self.category = "All"
                cell.cellLabel.text = "All"
            } else {
                self.category = currentMarket!.categories[indexPath.row - 1]
                cell.cellLabel.text = self.category
            }
            
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
                self.filter = "Most Recent"
                // print ("filter by Most Recent")
                filterPosts()
            } else if indexPath.row == 1 {
                self.filter = "Price: Low to High"
                // print ("filter by lowest price")
                filterPosts()
            } else {
                self.filter = "Price: High to Low"
                // print ("filter by highest price")
                filterPosts()
            }
            dropView?.hideMenu()
        } else {
            if indexPath.row == 0 {
                self.category = "All"
                print("selected all!")
            } else {
                print("getting index \(indexPath.row-1)")
                self.category = currentMarket!.categories[indexPath.row-1]
            }
            categoryTableView?.deselectRow(at: indexPath, animated: true)
//            self.category = currentMarket!.categories[indexPath.row]
            filterPosts()
            print ("The new category is \(self.category)")
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
                let detailViewController = segue.destination as! NewDetailViewController
                detailViewController.post = post
            }
        }
        if segue.identifier == "sideMenu" {
            let destination = segue.destination as! UINavigationController
            let destinationVC = destination.topViewController as! SidebarViewController
            destinationVC.markets = self.markets
            destinationVC.delegate = self
        }
    }
}
