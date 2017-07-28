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
    
    weak var marketCellDelegate: SelectedCategoryDelegate?
    
    // have a var for "categoryChanged"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
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
        cell.categoryNameLabel.text = market.categories[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCategory != nil {
            oldCategory = selectedCategory
        }
        selectedCategory = market.categories[indexPath.row]
        print (selectedCategory)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOk(_ sender: Any) {
        if let selectedCategory = selectedCategory {
            print ("it to the inside")
            if let oldCategory = oldCategory {
                delegate?.deselectCategory(marketName: market.name!)
            }
            let dict = [market.name! : selectedCategory]
            delegate?.choseCategory(category: dict)
//            marketCellDelegate?.setCategory(category: selectedCategory)
            delegate?.reloadCollectionView()
            self.dismiss(animated: true, completion: nil)
        }
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
