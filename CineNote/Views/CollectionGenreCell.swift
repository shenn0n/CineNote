//
//  CollectionGenreCell.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import UIKit

final class CollectionGenreCell: UICollectionViewCell {
    @IBOutlet var genreTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        backgroundColor = UIColor(named: "cell")
        genreTitleLabel.textColor = .white
    }
}
