//
//  TMDBResultModel.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import Foundation


class TMDBResultModel<T: Codable>: Codable {
    var results: T?
}
