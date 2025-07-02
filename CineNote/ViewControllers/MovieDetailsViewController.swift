//
//  MovieDetailsViewController.swift
//  CineNote
//
//  Created by Александр Манжосов on 02.07.2025.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var originalTitleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var voteAverageLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // навигационный бар маленьким
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        
    }
    
    private func configureUI(with movie: Movie) {
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        overviewLabel.text = movie.overview
        releaseDateLabel.text = movie.releaseDate
        voteAverageLabel.text = String(movie.voteAverage)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
}
