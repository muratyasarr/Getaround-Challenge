//
//  Constants.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

enum Constants {
    
    enum SceneTitles {
        static let Movies = "Movies"
        static let MovieDetails = "Movie Details"
    }
    
    enum Colors {
        static let darkBackgroundColor: UIColor = UIColor(
            red: 20/255.0,
            green: 20/255.0,
            blue: 20/255.0,
            alpha: 1
        )
    }
    
    enum Metrics {
        static let moviesCollectionViewLineSpacing: CGFloat = 0.0
        static let moviesCollectionViewInterItemSpacing: CGFloat = 0.0
        static let movieDetailsTextHorizontalMargin: CGFloat = 12.0
        static let movieDetailsTextVerticalMargin: CGFloat = 16.0
    }
    
    enum FontSizes {
        static let contentTitle: CGFloat = 22.0
    }
    
}
