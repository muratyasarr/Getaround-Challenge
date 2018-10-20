//
//  MoviesViewController.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit
import Kingfisher

final class MoviesViewController: BaseViewController {
    
    // MARK: - Properties
    var nowPlayingMovies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var searchResults: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var networkManager: NetworkManager
    
    // MARK:- View Declerations
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = Constants.Metrics.moviesCollectionViewInterItemSpacing
        flowLayout.minimumLineSpacing = Constants.Metrics.moviesCollectionViewLineSpacing
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        collectionView.backgroundColor = Constants.Colors.darkBackgroundColor
       return collectionView
    }()
    
    // MARK: - Initialization
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Custom Methods
    private func prepareUI() {
        title = Constants.SceneTitles.Movies
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              bottom: view.bottomAnchor)
        collectionView.reloadData()
        
        // Navigation Bar Customisation
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Search Bar Customisation
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func prepareData() {
        networkManager.request(MoviesEndpoint.nowPlaying) { [weak self] (result: Result<TMDBResultModel<[Movie]>>) in
            switch result {
            case .success(let result):
                guard let movies = result.results else { return }
                self?.nowPlayingMovies = movies
            case .error(let error):
                // TODO: Showing alert and informing users of the error should improve user experience.
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO: Pagination might be implemented for infinite scrollling experience. I leave it because I assume it as over-architecting in this scope. (reference point: "it should take you 3-5h, if you are spending more time, you are over-architecting.")
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.isEmpty ? nowPlayingMovies.count : searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        let movie = searchResults.isEmpty ? nowPlayingMovies[indexPath.row] : searchResults[indexPath.row]
        if let posterImagePath = movie.posterImagePath, let posterImageURL = URL(string: NetworkManager.Constants.TMDBConstants.imageBaseURL + posterImagePath) {
            movieCell.coverImageView.kf.setImage(with: posterImageURL)
        }
        return movieCell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width * 0.5
        return CGSize(width: width, height: width * 1.5)
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = searchResults.isEmpty ? nowPlayingMovies[indexPath.row] : searchResults[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController(movie: selectedMovie)
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkManager.request(MoviesEndpoint.search(queryText: searchText)) { [weak self] (result: Result<TMDBResultModel<[Movie]>>) in
            switch result {
            case .success(let result):
                guard let movies = result.results else { return }
                self?.searchResults = movies
            case .error(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
