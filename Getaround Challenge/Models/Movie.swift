//
//  Movie.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import Foundation

class Movie: Codable {
    var title: String?
    var posterImagePath: String?
    var backdropImagePath: String?
    var overview: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterImagePath = "poster_path"
        case backdropImagePath = "backdrop_path"
        case plotOverview
    }
}
