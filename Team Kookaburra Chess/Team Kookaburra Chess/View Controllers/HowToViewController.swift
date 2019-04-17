//
//  SearchForFriendsViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit

class HowToViewController: UIViewController {
    

    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadScrollView()
    }
    
    func loadScrollView(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackFromHowToSegue", sender: self)
    }
    
}
