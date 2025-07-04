//
//  MovieCollectionViewCell.swift
//  CineNote
//
//  Created by Александр Манжосов on 04.07.2025.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
        ratingLabel.text = nil
    }
    
    func configure(with movie: Movie) {
        posterImage.image = UIImage(named: "placeholder")
        ratingLabel.text = "★ " + String(format: "%.1f", movie.voteAverage)
        
        if let url = movie.posterURL {
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
}
