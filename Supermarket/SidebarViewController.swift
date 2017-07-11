//
//  SidebarViewController.swift
//  Supermarket
//
//  Created by Dominique Adapon on 7/11/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var marketTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketTableView.dataSource = self
        marketTableView.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 93.0/255.0, green: 202.0/255.0, blue: 206.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.isTranslucent = false
        
        definesPresentationContext = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // change later!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = marketTableView.dequeueReusableCell(withIdentifier: "MarketCell", for: indexPath) as! MarketCell
        return cell
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
