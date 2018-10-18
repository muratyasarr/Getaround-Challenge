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
    
    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
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
        prepareData()
    }
    
    private func prepareUI() {
        title = Constants.ScreenTitles.Movies
        self.view.addSubview(collectionView)
        collectionView.fillSuperView()
        collectionView.reloadData()
    }
    
    private func prepareData() {
        NetworkManager().request(MoviesEndpoint.nowPlaying) { (result: Result<TMDBResultModel<[Movie]>>) in
            switch result {
            case .success(let result):
                guard let movies = result.results else { return }
                self.movies = movies
            case .error(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO: Pagination might be implemented for infinite scrollling experience
    
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = movies[indexPath.row]
        // TODO: fetch image base url from a network related layer.
        if let posterImagePath = movie.posterImagePath, let posterImageURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterImagePath) {
            movieCell.coverImageView.kf.setImage(with: posterImageURL)
        }
        return movieCell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width * 0.5
        return CGSize(width: width, height: width * 1.5)
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
