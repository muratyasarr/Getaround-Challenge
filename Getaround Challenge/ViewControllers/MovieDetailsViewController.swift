//
//  MovieDetailsViewController.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.contentTitle)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        title = Constants.SceneTitles.MovieDetails
        self.navigationItem.largeTitleDisplayMode = .never
        scrollView.addSubview(backdropImageView)
        scrollView.addSubview(movieTitleLabel)
        scrollView.addSubview(movieOverviewLabel)
        view.addSubview(scrollView)
        setupContent()
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.fillSuperView()
        backdropImageView.anchor(top: scrollView.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 0.7).isActive = true
        movieTitleLabel.anchor(top: backdropImageView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: movieOverviewLabel.topAnchor, padding: .init(top: Constants.Metrics.movieDetailsTextVerticalMargin, left: Constants.Metrics.movieDetailsTextHorizontalMargin, bottom: Constants.Metrics.movieDetailsTextVerticalMargin, right: Constants.Metrics.movieDetailsTextHorizontalMargin))
        movieOverviewLabel.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: scrollView.bottomAnchor, padding: .init(top: 0.0, left: Constants.Metrics.movieDetailsTextHorizontalMargin, bottom: Constants.Metrics.movieDetailsTextVerticalMargin, right: Constants.Metrics.movieDetailsTextHorizontalMargin))
    }
    
    private func setupContent() {
        if let posterImagePath = movie.backdropImagePath, let posterImageURL = URL(string: NetworkManager.Constants.imageBaseURL + posterImagePath) {
            backdropImageView.kf.setImage(with: posterImageURL)
        }
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
    }
}
