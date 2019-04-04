//
//  YourFriendsViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit

class YourFriendsViewController: UIViewController {
    
    @IBOutlet weak var yourFriendsLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "YourFriendsBackBtSegue", sender: self)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}
