//
//  myFriendsViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/29/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class MyFriendsViewController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func searchForFriendsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SearchForFriendsSegue", sender: self)
    }
    
    @IBAction func BackFromMyFriendsBtPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackFromMyFriendsSegue", sender: self)
    }
    
}
