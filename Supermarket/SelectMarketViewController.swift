//
//  SelectMarketViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 7/23/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import BouncyLayout


protocol CategoryDelegate: class {
    func choseCategory(category: [String: String])
    func deselectCategory(marketName: String)
    func reloadCollectionView()
}

class SelectMarketViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable, CategoryDelegate {
    
    
    
    // to receive from choose location vc
    var itemName: String!
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
    
    @IBOutlet weak var postButton: UIButton!

    // Activity Indicator Font
//    let activityFontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
    let activityFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"]), size: 20)

    
    // before making post, check if any images are the placeholder image
    // meaning user did not select their own image
    
    @IBAction func previousAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postAction(_ sender: UIButton) {
        
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
        
        // style navigation bar
        self.title = "Select Markets"
        let font = UIFontDescriptor(fontAttributes: [UIFontDescriptorFaceAttribute : "Medium", UIFontDescriptorFamilyAttribute: "Avenir"])
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(descriptor: font, size: 20)]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        // make navbar translucent (remove bottom line)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Style collection view
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        collectionView.collectionViewLayout = BouncyLayout(style: BouncyLayout.BounceStyle.subtle)
        
//        let layout = collectionView.collectionViewLayout
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        



        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = layout.minimumInteritemSpacing

        let cellsPerLine: CGFloat = 2
        // this is fine, just lock the orientation

        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine

        layout.itemSize = CGSize(width: width, height: width * 7/5)
//
        
        
        
        // Style Post button
        postButton.layer.cornerRadius = 5
        
        

        let marketIds = PFUser.current()?.value(forKey: "markets") as! [String]
        // print (marketIds)
        let query = PFQuery(className: "Market")
        query.whereKey("objectId", containedIn: marketIds)
        
        query.findObjectsInBackground { (markets, error) in
            if let error = error {
                // print ("trouble loading the markets: \(error.localizedDescription)")
            } else if let markets = markets {
                for m in markets {
                    let market = Market(m)
                    self.markets.append(market)
                }
                // print ("the number of markets found was: \(markets.count)")
                // print ("okay we got the list of markets")
                self.collectionView.reloadData()
            } else {
                // print ("there was no error but no markets were loaded")
            }
            
        }
        
        
        var tempImageList: [UIImage] = []
        tempImageList.append(coverPhoto.image!) // should I force unwrap this?
        tempImageList.append(imageOne.image!)
        tempImageList.append(imageTwo.image!)
        tempImageList.append(imageThree.image!)
        tempImageList.append(imageFour.image!)
        // MAN THIS TAKES A LONG TIME... CHANGE STRUCTURE SO THAT IMAGE GETS PASSED INSTEAD OF THE UIIMAGEVIEW
        
        var imageList: [UIImage] = []
        for im in tempImageList {
            if im != UIImage(named: "cameraMask") {
                imageList.append(im)
            }
        }
        
        // ALL INFO
//        print("NAME: \(itemName)")
//        print("COVER PHOTO: \(coverPhoto.image)")
//        print("IMAGES: \(imageOne.image), \(imageTwo.image), \(imageThree.image), \(imageFour.image)")
//        print("NEGOTIABLE: \(isNegotiable)")
//        print("PRICE: \(itemPrice)")
//        print("NEW: \(isNew)")
//        print("DESCRIPTION: \(itemDescription.text)")
//        print("LATITUDE: \(latitude)")
//        print("LONGITUDE: \(longitude)")
//        print("CITY: \(city)")
//
//        print (imageOne.image?.size.height)
//        print (imageOne.image?.size.width )
//        print (imageTwo.image?.size.height )
//        print (imageTwo.image?.size.width )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postToMarkets(_ sender: Any) {
        if marketsToPost.keys.count == 0 {
            // print ("it will not post if no markets have been specified")
        } else {
            // Show activity indicator
            self.startAnimating(message: "Posting Item", messageFont: activityFont, type: NVActivityIndicatorType.ballPulse, textColor: UIColor.white)

//            self.startAnimating(type: NVActivityIndicatorType.ballPulse)
            
            // clean up so that you pass UIImages themselves instead of ImageViews...
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
            
            var actualImages: [UIImage] = []
            for image in imageList {
                actualImages.append( Post.resizeImage(image: image, targetSize: CGSize(width: 512, height: 512)) )
            }

            let toPost = Post.createPost(images: actualImages, name: itemName, seller: PFUser.current()!, itemDescription: itemDescription.text, price: itemPrice, conditionNew: isNew, negotiable: isNegotiable, sold: false, city: city!, latitude: latitude!, longitude: longitude!)
            
            toPost.parseObject.saveInBackground { (success, error) in // so you don't want to save in backround in the class itself... you want to save in background whenever you create a new post outside the class!
                if success {
                    for (market, category) in self.marketsToPost {
                        toPost.parseObject.fetchIfNeededInBackground(block: { (post, error) in
                            if let post = post {
                                // print("just fetched: \(post)")
                                let newPost = Post(post)
                                // print("about to post to market!")
                                // print("post id: \(newPost.parseObject.objectId)")
                                MarketPost.postItem(post: newPost, marketName: market, category: category)
                                // print("Posted to market!")
                                
                                // Stop activity indicator
                                self.stopAnimating()
                                self.backToHome()
                            }
                        })
                    }
                }
            }
            
        }
    }
    
    func backToHome() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        UIView.performWithoutAnimation {
//            self.show(vc, sender: self)
            present(vc, animated: true, completion: nil)
            vc.selectedIndex = 0
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return markets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketChoiceCell", for: indexPath) as! MarketChoiceCell
        
        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 15
        
        let market = markets[indexPath.row]
        
        cell.marketProfileImage.file = market.profileImage
        
        cell.marketProfileImage.loadInBackground()
        cell.marketName.text = market.name
        
//        cell.categoryLabel.textColor = UIColor.white
        
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = Constants.Colors.ourGray.cgColor
        
        if let selectedCategory = marketsToPost[market.name!] {
            cell.categoryLabel.text = selectedCategory
            cell.layer.backgroundColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
            cell.marketName.textColor = UIColor.white
//            cell.layer.borderWidth = 0
            
        } else {
            cell.categoryLabel.text = ""
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.marketName.textColor = UIColor.black
            cell.layer.borderWidth = 1
            cell.layer.borderColor = Constants.Colors.ourGray.cgColor
        }
        
        
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
        // print (marketsToPost)
    }
    
    func deselectCategory(marketName: String) {
//        dict.removeValue(forKey: willRemoveKey)
        marketsToPost.removeValue(forKey: marketName)
        // print("pls delete this marketcategory")
        print(marketsToPost)
    }
    
    func reloadCollectionView() {
         collectionView.reloadData()
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
