//
//  MoviesViewController.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesViewController: BaseViewController {
    
    var movies: [Movie] = [Movie(), Movie()]
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        collectionView.backgroundColor = Constants.Colors.darkBackgroundColor
       return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        title = Constants.ScreenTitles.Movies
        self.view.addSubview(collectionView)
        collectionView.fillSuperView()
        collectionView.reloadData()
        
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        movieCell.coverImageView.kf.setImage(with: <#T##Resource?#>)
        return movieCell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width/2.0
        return CGSize(width: width, height: width*2.0)
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
