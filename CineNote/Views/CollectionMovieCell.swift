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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }
}
