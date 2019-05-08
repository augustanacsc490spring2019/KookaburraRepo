//
//  GameViewController.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 3/18/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //window?.rootViewController = ChessVC(coder: <#NSCoder#>)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
