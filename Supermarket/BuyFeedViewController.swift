//
//  BuyFeedViewController.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/10/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class BuyFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var postTableView: UITableView!
    
    var searchController: UISearchController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "rice cooker")
    
        print(image)
//        Post.postItem(images: <#T##[UIImage]?#>, name: <#T##String#>, itemDescription: <#T##String#>, price: <#T##Double#>, conditionNew: <#T##Bool#>, negotiable: <#T##Bool#>, latitude: <#T##Double#>, longitude: <#T##Double#>)
        
        Post.postItem(images: nil, name: "Rice cooker", itemDescription: "A medium-sized rice cooker that's perfect for college dorms!", price: 20.00, conditionNew: false, negotiable: false, latitude: 33.640495, longitude: -117.844296)
        
        
        postTableView.dataSource = self
        postTableView.delegate = self

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
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // change to posts.count once you have parse and stuff...
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postTableView.dequeueReusableCell(withIdentifier: "BuyFeedCell", for: indexPath) as! BuyFeedCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {

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
