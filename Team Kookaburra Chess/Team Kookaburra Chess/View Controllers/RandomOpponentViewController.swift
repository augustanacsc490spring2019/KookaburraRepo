//
//  RandomOpponentViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit

class RandomOpponentViewController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "PlayRandomOppSegue", sender: self)
    }
    
    @IBAction func backFromRanOppBtPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackFromRanOppSegue", sender: self)
    }
    
}
