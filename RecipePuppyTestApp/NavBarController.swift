//
//  NavBarController.swift
//  RecipePuppyTestApp
//
//  Created by Pyvovarov Andrii on 29.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

import UIKit

class NavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.1756276488, green: 0.5336883664, blue: 0.01125960331, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
