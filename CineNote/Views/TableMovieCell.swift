//
//  TableMovieCell.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import UIKit

final class TableMovieCell: UITableViewCell {
    @IBOutlet var categoryTitleLabel: UILabel!
    @IBOutlet var collectionMovieView: UICollectionView!
    
    private let networkManager = NetworkManager.shared
    var movies: [Movie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionMovieView.delegate = self
        collectionMovieView.dataSource = self
        collectionMovieView.backgroundColor = .clear
        categoryTitleLabel.textColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionMovieView.setContentOffset(.zero, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addVerticalGradientLayer(
            topColor: UIColor(named: "top") ?? .clear,
            bottomColor: UIColor(named: "bottom") ?? .clear
        )
        contentView.updateGradientFrame()
    }
}

// MARK: - Collection View Delegates
extension TableMovieCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == movies.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paginationCell", for: indexPath)
            guard let cell = cell as? CollectionPaginatiomMovieCell else { return UICollectionViewCell() }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionMovieCell", for: indexPath)
            guard let cell = cell as? CollectionMovieCell else { return UICollectionViewCell() }
            
            let movie = movies[indexPath.item]
            cell.posterImage.image = UIImage(named: "placeholder") // очистка при переиспользовании
            cell.ratingLabel.text = "★ " + String(format: "%.1f", movie.voteAverage)
            
            if let url = movie.posterURL {
                networkManager.fetchImage(from: url) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let imageData):
                            // проверяем, не переиспользована ли ячейка
                            if let currentIndex = collectionView.indexPath(for: cell), currentIndex == indexPath {
                                cell.posterImage.image = UIImage(data: imageData)
                            }
                        case .failure(let error):
                            print("Ошибка загрузки изображения: \(error)")
                        }
                    }
                }
            }
            return cell
        }
    }
}

extension TableMovieCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = height * 2 / 3
        return CGSize(width: width, height: height)
    }
}
