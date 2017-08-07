//
//  SellFeedViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/19/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import TableViewReloadAnimation

class SellFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ModalDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedView: UIView!
    
    @IBOutlet weak var lineViewOne: UIView!
    @IBOutlet weak var lineViewTwo: UIView!
    
    @IBOutlet weak var postTableView: UITableView!
    var posts: [Post] = []
    var sellingPosts: [Post] = []
    var soldPosts: [Post] = []
    var currentMarket: Market?
    var markets: [Market] = []
    
    var items : [String] = ["Selling", "Sold"]
    var detailPost: Post?
    
    let ourColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // make sure tab bar is there
        self.tabBarController?.tabBar.isHidden = false
        
//        let image = UIImage(named: "TeamProfileImage.jpg")
//        print ("this is the image: \(image)")
//        let file = Post.getPFFileFromImage(image: image)
//        PFUser.current()!["profileImage"] = file
//        PFUser.current()?.saveInBackground(block: { (success, error) in
//            if let error = error {
//                print (error.localizedDescription)
//            } else if success {
//                print ("success")
//            } else {
//                print ("WHAAAAAAT")
//            }
//        })
        
        postTableView.dataSource = self
        postTableView.delegate = self

        self.postTableView.tableFooterView = UIView()
        
        lineViewOne.backgroundColor = ourColor
        lineViewTwo.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]
        navigationController?.navigationBar.barTintColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        definesPresentationContext = true
        
        segmentedControl.tintColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        segmentedControl.layer.masksToBounds = true
        segmentedControl.tintColor = UIColor.clear
        
        // segmentedView.addTarget(self, action: #selector(SellFeedViewController.segmentedViewControllerValueChanged(_:)), for: .valueChanged)
        // segmentedView.backgroundColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        // let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        // UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : ourColor,
            NSFontAttributeName as NSObject: UIFont(name: "Avenir", size: 16)!
            ]
        let boldTextAttributes2: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName as NSObject : UIColor.black,
            NSFontAttributeName as NSObject: UIFont(name: "Avenir", size: 16)!
        ]
        segmentedControl.setTitleTextAttributes(boldTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(boldTextAttributes2, for: .normal)
        

        
        setFirstMarket()
        
//        var query = PFQuery(className: "Post")
//        query.whereKey("sold", equalTo: false)
//        // query.whereKey("seller", equalTo: PFUser.current())
//        query.limit = 20
//
//        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
//            if let posts = posts {
//                print (posts.count)
//                print ("IT FOUND POSTS")
//                for item in posts {
//                    let post = Post(item)
//                    self.sellingPosts.append(post)
//                }
//
//                self.posts = self.sellingPosts
//                self.postTableView.reloadData()
//
//                // let notification = Notification.createNotification(withSender: PFUser.current()!, withReceiver: PFUser.current()!, withMessage: "is interested in your", withPostObject: posts[0])
//            } else if error != nil {
//                print (error?.localizedDescription)
//            } else {
//                print ("the posts could not be loaded into the sell feed")
//            }
//
//        }
//
//        var secondQuery = PFQuery(className: "Post")
//        secondQuery.whereKey("sold", equalTo: true)
//        // query.whereKey("seller", equalTo: PFUser.current())
//        secondQuery.limit = 20
//
//        secondQuery.findObjectsInBackground { (posts, error) in
//            if let posts = posts {
//                print (posts.count)
//                print ("IT FOUND POSTS")
//                for item in posts {
//                    let post = Post(item)
//                    self.soldPosts.append(post)
//                }
//
//                self.posts = self.sellingPosts
//                self.postTableView.reloadData()
//            } else if error != nil {
//                print (error?.localizedDescription)
//            } else {
//                print ("the posts could not be loaded into the sell feed")
//            }
//        }
        
        
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
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)!]
        navigationController?.navigationBar.barTintColor = UIColor(red: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("the count is \(posts.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "SellFeedCell", for: indexPath) as! SellFeedCell
        if posts.count > 0 {
            cell.post = posts[indexPath.row]
        }
        // cell.preservesSuperviewLayoutMargins = false
        // cell.separatorInset = UIEdgeInsets.zero
        // cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }

    func segmentedViewControllerValueChanged(_ sender: Any) {
        
    }
    
    @IBAction func segmentDidChange(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.posts = sellingPosts
            lineViewOne.backgroundColor = ourColor
            lineViewTwo.backgroundColor = UIColor.clear
        } else {
            self.posts = soldPosts
            lineViewOne.backgroundColor = UIColor.clear
            lineViewTwo.backgroundColor = ourColor
        }
        self.postTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postTableView.deselectRow(at: indexPath, animated: true)
        self.detailPost = posts[indexPath.row]
        self.performSegue(withIdentifier: "sellToDetail", sender: self)
        
    }
    
    func changedMarket(market: Market) {
        self.posts = []
        self.sellingPosts = []
        self.soldPosts = []
        currentMarket = market
        // print (currentMarket?.name!)
        self.navigationItem.title = self.currentMarket!.name
        loadPosts()
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
                self.currentMarket = self.markets[0]
                let marketName = self.currentMarket?.name
                self.navigationItem.title = marketName
                self.loadPosts()
                // self.postTableView.reloadData()
            }
            else {
                print("Error getting markets: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func loadPosts() {

        startAnimating(type: NVActivityIndicatorType.ballPulse, color: Constants.Colors.ourGray, backgroundColor: UIColor.clear)
        
        let query = PFQuery(className: "MarketPost")
        query.addDescendingOrder("createdAt")
        query.whereKey("market", equalTo: currentMarket!.name)
        self.posts = []
        // var localPosts: [Post] = []
        query.findObjectsInBackground { (marketPosts, error) in
            if let marketPosts = marketPosts {
                // print ("it found \(marketPosts.count) market posts")
                var idArray: [String] = []
                for m in marketPosts {
                    let marketPost = MarketPost(m)
                    let postID = marketPost.post
                    idArray.append(postID!)
                }
                let postQuery = PFQuery(className: "Post")
                postQuery.addDescendingOrder("createdAt")
                // change this to "updatedAt" for sold...
                
                postQuery.whereKey("objectId", containedIn: idArray)
                postQuery.whereKey("seller", equalTo: "_User$" + (PFUser.current()?.objectId)!)
                postQuery.findObjectsInBackground(block: { (posts, error) in
                    if let posts = posts {
                        // let notification = SupermarketNotification.createNotification(withSender: PFUser.current()!, withReceiver: PFUser.current()!, withMessage: " is interested in your ", withPostObject: posts[0])
                        for p in posts {
                            let post = Post(p)
                            if post.sold == true {
                                self.soldPosts.append(post)
                            } else {
                                self.sellingPosts.append(post)
                            }
                        }
                        self.soldPosts.sort(by: { (post1, post2) -> Bool in
                            return Int((post1.parseObject.updatedAt?.timeIntervalSinceNow)!) > Int((post2.parseObject.updatedAt?.timeIntervalSinceNow)!)
                        })
                        
                        if self.segmentedControl.selectedSegmentIndex == 0 {
                            self.posts = self.sellingPosts
                        } else {
                            self.posts = self.soldPosts
                        }
//                        self.postTableView.reloadData()
                        
                        self.postTableView.reloadData(with: UITableView.AnimationType.simple(duration: 0.75, direction: .top(useCellsFrame: true), constantDelay: 0), reversed: false, completion: nil)
                        self.stopAnimating()
                    }
                })
//                for m in marketPosts {
//                    let marketPost = MarketPost(m)
//                    let post = Post(marketPost.post)
//                    let parseObject = post.parseObject
//                    parseObject.fetchInBackground(block: { (parseObject, error) in
//                        if let parseObject = parseObject {
//                            print("in fetchifneeded")
//                            if post.sold == false {
//                                print ("post sold was false")
//                                self.sellingPosts.append( Post(parseObject) )
//                                // self.postTableView.reloadData()
//                                // localPosts.append(post)
//                            } else {
//                                print ("post sold was true")
//                                self.soldPosts.append( Post(parseObject) )
//                            }
//                            self.postTableView.reloadData()
//                        }
//                    })
//                }
            }
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sellToDetail" {
            // clear back button text
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            
            let destination = segue.destination as! NewDetailViewController
            destination.post = self.detailPost!
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
            destinationVC.markets = self.markets
            // print("destination VC: \(destinationVC)")
            destinationVC.delegate = self
        }
     }
}
