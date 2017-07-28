//
//  DetailViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var post: Post = Post()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        
        self.title = "Item Details"
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir", size: 20)]
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        automaticallyAdjustsScrollViewInsets = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPictureCell") as! DetailPictureCell
            
            cell.postImage = post.parseObject
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailInformationCell") as! DetailInformationCell
            
            
            let name = post.name
            cell.nameLabel.text = name
            
            let price = post.price!
            let formattedPrice = String(format: "%.2f", price)
            cell.priceLabel.text = "$\(formattedPrice)"
            
            let new = post.conditionNew
            var conditionString = ""
            if new! {
                conditionString = "New"
            }
            cell.conditionLabel.text = conditionString
            
//            let latitude = post.latitude!
//            print("LATITUDE: \(latitude)")
//            let longitude = post.longitude!
            cell.locationLabel.text = post.city!
            
            let timestamp = post.parseObject["_created_at"] as? String // change this...
            // maybe change this to a var so you can format it...
            cell.timestampLabel.text = timestamp
            
            let description = post.itemDescription
            cell.descriptionLabel.text = description
            
            cell.post = self.post
            
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
