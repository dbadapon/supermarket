//
//  SelectMarketViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse

protocol CategoryDelegate: class {
    func choseCategory(category: [String: String])
    func deselectCategory(marketName: String)
}

class SelectMarketViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CategoryDelegate {
    
    
    
    // to receive from choose location vc
    var itemName: UITextView!
    var coverPhoto: UIImageView!
    var imageOne: UIImageView!
    var imageTwo: UIImageView!
    var imageThree: UIImageView!
    var imageFour: UIImageView!
    var isNegotiable: Bool!
    var itemPrice: Double!
    var isNew: Bool!
    var itemDescription: UITextView!
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var markets: [Market] = []
    var marketsToPost: [String: String] = [:]
    var selectedMarket: Market? = nil
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // before making post, check if any images are the placeholder image
    // meaning user did not select their own image
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        
        // let's hard-code the latitude and longitude for now... and city lol
        latitude = 33.640495
        longitude = -117.844296
        city = "Irvine, CA"
        //isNew = true
        
        var tempImageList: [UIImage] = []
        tempImageList.append(coverPhoto.image!) // should I force unwrap this?
        tempImageList.append(imageOne.image!)
        tempImageList.append(imageTwo.image!)
        tempImageList.append(imageThree.image!)
        tempImageList.append(imageFour.image!)
        
        var imageList: [UIImage] = []
        for im in tempImageList {
            if im != UIImage(named: "cameraMask") {
                imageList.append(im)
            }
        }
        
        
        
        
        print("NAME: \(itemName.text)")
        print("COVER PHOTO: \(coverPhoto.image)")
        print("IMAGES: \(imageOne.image), \(imageTwo.image), \(imageThree.image), \(imageFour.image)")
        print("NEGOTIABLE: \(isNegotiable)")
        print("PRICE: \(itemPrice)")
        print("NEW: \(isNew)")
        print("DESCRIPTION: \(itemDescription.text)")
        print("LATITUDE: \(latitude)")
        print("LONGITUDE: \(longitude)")
        print("CITY: \(city)")
        
//        let toPost = Post.createPost(images: imageList, name: itemName.text, seller: PFUser.current()!, itemDescription: itemDescription.text, price: itemPrice, conditionNew: isNew, negotiable: isNegotiable, sold: false, city: city!, latitude: latitude!, longitude: longitude!)
        
        // let marketsToPost = ["UCI Free and For Sale": "Books"]
        
//        toPost.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
//            if success {
//                for (market, category) in marketsToPost {
//                    toPost.parseObject.fetchIfNeededInBackground(block: { (post, error) in
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
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Style collection view
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        
        layout.itemSize = CGSize(width: width, height: width * 3/2)
        
        
        
        let marketIds = PFUser.current()?.value(forKey: "markets") as! [String]
        print (marketIds)
        let query = PFQuery(className: "Market")
        query.whereKey("objectId", containedIn: marketIds)
        
        query.findObjectsInBackground { (markets, error) in
            if let error = error {
                print ("trouble loading the markets: \(error.localizedDescription)")
            } else if let markets = markets {
                for m in markets {
                    let market = Market(m)
                    self.markets.append(market)
                }
                print ("the number of markets found was: \(markets.count)")
                print ("okay we got the list of markets")
                self.collectionView.reloadData()
            } else {
                print ("there was no error but no markets were loaded")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postToMarkets(_ sender: Any) {
        if marketsToPost.keys.count == 0 {
            print ("it will not post if no markets have been specified")
        } else {
            var tempImageList: [UIImage] = []
            tempImageList.append(coverPhoto.image!) // should I force unwrap this?
            tempImageList.append(imageOne.image!)
            tempImageList.append(imageTwo.image!)
            tempImageList.append(imageThree.image!)
            tempImageList.append(imageFour.image!)
            
            var imageList: [UIImage] = []
            for im in tempImageList {
                if im != UIImage(named: "cameraMask") {
                    imageList.append(im)
                }
            }

            let toPost = Post.createPost(images: imageList, name: itemName.text, seller: PFUser.current()!, itemDescription: itemDescription.text, price: itemPrice, conditionNew: isNew, negotiable: isNegotiable, sold: false, city: city!, latitude: latitude!, longitude: longitude!)
            
            toPost.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
                if success {
                    for (market, category) in self.marketsToPost {
                        toPost.parseObject.fetchIfNeededInBackground(block: { (post, error) in
                            if let post = post {
                                print("just fetched: \(post)")
                                let newPost = Post(post)
                                print("about to post to market!")
                                print("post id: \(newPost.parseObject.objectId)")
                                MarketPost.postItem(post: newPost, marketName: market, category: category)
                                print("Posted to market!")
                            }
                        })
                    }
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print ("it's getting here")
        return markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print ("it's getting here")
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketChoiceCell", for: indexPath) as! MarketChoiceCell
        
        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.black.cgColor
        
        let market = markets[indexPath.row]
        
        cell.marketProfileImage.file = market.profileImage
        
        cell.marketProfileImage.loadInBackground()
        cell.marketName.text = market.name
        
        
        if marketsToPost.keys.contains(market.name!) {
            cell.isSelected = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMarket = markets[indexPath.row]
        self.performSegue(withIdentifier: "toCategorySelection", sender: self)
    }
    
    func choseCategory(category: [String : String]) {
        let marketName = category.keys.first
        let categoryName = category[marketName!]
        marketsToPost[marketName!] = categoryName
        print (marketsToPost)
    }
    
    func deselectCategory(marketName: String) {
//        dict.removeValue(forKey: willRemoveKey)
        marketsToPost.removeValue(forKey: marketName)
        print("pls delete this marketcategory")
        print(marketsToPost)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toCategorySelection" {
            let destination = segue.destination as! SelectCategoryViewController
            destination.market = self.selectedMarket
            destination.delegate = self
            print("THE DESTINATION MARKET IS: \(destination.market)")
        }
    }
    

}
