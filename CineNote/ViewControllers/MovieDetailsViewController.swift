//
//  MovieDetailsViewController.swift
//  CineNote
//
//  Created by Александр Манжосов on 02.07.2025.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var originalTitleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var voteAverageLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    private var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // навигационный бар маленьким
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        if let movie = movie {
            configureUI(with: movie)
        }
    }
    
    func setMovie(_ movie: Movie) {
        self.movie = movie
    }
    
    private func configureUI(with movie: Movie) {
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        overviewLabel.text = movie.overview
        releaseDateLabel.text = movie.releaseDate
        voteAverageLabel.text = String(format: "%.1f", movie.voteAverage)
        
        if let url = movie.backdropURL {
            NetworkManager.shared.fetchImage(from: url) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let imageData):
                    self.posterImage.image = UIImage(data: imageData)
                case .failure(let error):
                    print("Ошибка загрузки постера: \(error)")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
}
