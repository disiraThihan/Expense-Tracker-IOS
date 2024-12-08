//
//  HomeView.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import UIKit

class HomeView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            viewControllers.remove(at: viewControllers.count - 2) 
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
    
}
