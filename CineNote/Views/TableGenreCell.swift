//
//  TableGenreCell.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import UIKit

final class TableGenreCell: UITableViewCell {
    @IBOutlet var collectionGenreView: UICollectionView!
    var genres: [Genre] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionGenreView.delegate = self
        collectionGenreView.dataSource = self
        collectionGenreView.backgroundColor = .clear
    }
}

extension TableGenreCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionGenreCell", for: indexPath)
        if let cell = cell as? CollectionGenreCell {
            cell.genreTitleLabel.text = genres[indexPath.item].name.uppercased()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // два столбика
        let numberOfColumns: CGFloat = 2
        let totalSpacing: CGFloat = 10
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        
        // расчёт высоты
        let labelHeight: CGFloat = 40 // например, высота одной строки текста
        let padding: CGFloat = 16 // отступы сверху/снизу
        let itemHeight = labelHeight + padding
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
