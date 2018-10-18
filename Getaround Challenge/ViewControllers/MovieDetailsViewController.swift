//
//  MovieDetailsViewController.swift
//  Getaround Challenge
//
//  Created by Guest User on 18.10.2018.
//  Copyright © 2018 Guest User. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    let movie: Movie
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
//        scrollView.addSubview(contentView)
        return scrollView
    }()
    
//    lazy var contentView: UIView = {
//        let view = UIView()
//        view.addSubview(backdropImageView)
//        view.addSubview(movieTitleLabel)
//        view.addSubview(movieOverviewLabel)
//        return view
//    }()
    
    lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()
    
    lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
        return label
    }()
    
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
//        contentView.fillSuperView()
        backdropImageView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor)
        backdropImageView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        movieTitleLabel.anchor(top: backdropImageView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: movieOverviewLabel.topAnchor, padding: .init(top: 16.0, left: 8.0, bottom: 16.0, right: 8.0))
        movieOverviewLabel.anchor(leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor, padding: .init(top: 0.0, left: 8.0, bottom: 8.0, right: 8.0))
    }
    
    private func setupContent() {
        if let posterImagePath = movie.backdropImagePath, let posterImageURL = URL(string: NetworkManager.Constants.imageBaseURL + posterImagePath) {
            backdropImageView.kf.setImage(with: posterImageURL)
        }
        movieTitleLabel.text = movie.title
        movieOverviewLabel.text = movie.overview
    }

}
