//
//  SelectCategoryViewController.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/27/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var market: Market!
    var selectedCategory: String?
    var oldCategory: String?
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: CategoryDelegate?
    
    // have a var for "categoryChanged"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        // Style navigation bar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return market.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
//        cell.categoryNameLabel.text = market.categories[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        if indexPath.row == 0 {
            cell.categoryNameLabel.text = "None"
//            selectedCategory = nil
        } else {
            cell.categoryNameLabel.text = market.categories[indexPath.row-1]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            oldCategory = selectedCategory
            selectedCategory = nil
        }
        else {
//            oldCategory = selectedCategory
            selectedCategory = market.categories[indexPath.row-1]
        }
        print (selectedCategory)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOk(_ sender: Any) {
        delegate?.deselectCategory(marketName: market.name!)
        if let selectedCategory = selectedCategory {
            print ("it to the inside")
            if selectedCategory != nil {
                let dict = [market.name! : selectedCategory]
                delegate?.choseCategory(category: dict)
            }
        }
        delegate?.reloadCollectionView()
        self.dismiss(animated: true, completion: nil)
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
