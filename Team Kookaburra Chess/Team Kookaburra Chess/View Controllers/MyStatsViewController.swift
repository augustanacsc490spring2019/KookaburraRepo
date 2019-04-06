//
//  MyStatsViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/29/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class MyStatsViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var winsLosesLabel: UILabel!
    
    @IBOutlet weak var numPiecesLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backFromStatsMenuBtPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackFromStatsMenuSegue", sender: self)
    }
    
    
}
