//
//  BaseSearchNavigationController.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class BaseSearchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    private func prepareUI() {
        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = Constants.Colors.darkBackgroundColor
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = false
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self.viewControllers.first as? UISearchResultsUpdating
        self.navigationItem.searchController = search
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
