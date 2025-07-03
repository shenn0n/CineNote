//
//  SearchTableViewCell.swift
//  CineNote
//
//  Created by Александр Манжосов on 02.07.2025.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var originalTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }


    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        originalTitleLabel.text = movie.originalTitle
        posterImage.image = nil
        
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
