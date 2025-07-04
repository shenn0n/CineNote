//
//  CollectionMovieCell.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import UIKit

final class CollectionMovieCell: UICollectionViewCell {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    
    var movieID: Int?
    private let networkManager = NetworkManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
        ratingLabel.text = nil
        movieID = nil
    }
    
    func configureUI(with movie: Movie) {
        movieID = movie.id // сохраняем ID
        posterImage.image = UIImage(named: "placeholder") // очистка при переиспользовании
        ratingLabel.text = "★ " + String(format: "%.1f", movie.voteAverage)
        
        if let url = movie.posterURL {
            networkManager.fetchImage(from: url) { [weak self] result in
                guard let self else { return }
                if self.movieID == movie.id { // проверка соответствия
                    switch result {
                    case .success(let imageData):
                        self.posterImage.image = UIImage(data: imageData)
                    case .failure(let error):
                        print("Ошибка загрузки изображения: \(error)")
                    }
                }
            }
        }
    }
}
