//
//  Movie.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import Foundation

class Movie: Codable {
    let title: String?
    let posterImagePath: String?
    let backdropImagePath: String?
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterImagePath = "poster_path"
        case backdropImagePath = "backdrop_path"
        case overview
    }
}
