//
//  SidebarViewController.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol ModalDelegate: class {
    func changedMarket(market: Market)
}

protocol MarketCellDelegate: class {
    func didTapInfo(of market: Market)
}

class SidebarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MarketCellDelegate {

    @IBOutlet weak var marketTableView: UITableView!
    
    var markets: [Market] = []
    
    var feedViewController: BuyFeedViewController? = nil
    
    weak var delegate: ModalDelegate?
    
    var infoMarket: Market?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("sidebar viewDidLoad")
        print(self.navigationController)
        
        marketTableView.dataSource = self
        marketTableView.delegate = self
        
        
   
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        definesPresentationContext = true

        
        // fetch data from database
        queryParse()
        
    }
    
    func queryParse() {
        let query = PFQuery(className: "Market")
        query.addAscendingOrder("name")
        query.findObjectsInBackground { (markets: [PFObject]?, error: Error?) in
            if let markets = markets {
                for m in markets {
                    let market = Market(m)
                    self.markets.append(market)
                }
//                self.markets = markets
                self.marketTableView.reloadData()
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count // change later!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = marketTableView.dequeueReusableCell(withIdentifier: "MarketCell", for: indexPath) as! MarketCell
        
        let market = markets[indexPath.row]
        cell.market = market
        cell.delegate = self
        cell.marketName.text = market.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        marketTableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = self.delegate {
            print("the delegate is not nil!")
            delegate.changedMarket(market: markets[indexPath.row])
        } else {
            print("the delegate is nil :(")
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func didTapInfo(of: Market) {
        self.infoMarket = of
        self.performSegue(withIdentifier: "toMarketDetail", sender: self)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMarketDetail" {
            let destination = segue.destination as! MarketViewController
            destination.market = self.infoMarket 
        }
    }
    

}
