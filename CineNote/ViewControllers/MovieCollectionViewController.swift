//
//  MovieCollectionViewController.swift
//  CineNote
//
//  Created by Александр Манжосов on 03.07.2025.
//

import UIKit

private let reuseIdentifier = "movieGenreCell"

class MovieCollectionViewController: UICollectionViewController {
    var genreId: Int!
    var genryTitle: String!
    weak var delegate: TableMovieCellDelegate?
    private let networkManager = NetworkManager.shared
    private var movies: [Movie] = []
    private var toggleButton: UIBarButtonItem!
    private var columnsCount: CGFloat = 2 {
        didSet {
            updateBarButtonIcon()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = genryTitle.prefix(1).uppercased() + genryTitle.dropFirst()
        toggleButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.split.3x3.fill"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(toggleColumns))
        navigationItem.rightBarButtonItem = toggleButton

        loadMoviesByGenre()
    }
    
    @objc private func toggleColumns() {
        columnsCount = columnsCount == 2 ? 3 : 2
        collectionView.collectionViewLayout.invalidateLayout() // Принудительное обновление layout
    }
    
    private func updateBarButtonIcon() {
        let iconName = columnsCount == 2 ? "rectangle.split.3x3.fill" : "rectangle.split.2x2.fill"
        toggleButton.image = UIImage(systemName: iconName)
    }
    
    private func loadMoviesByGenre() {
        networkManager.fetchMoviesByGenre(genreId: genreId) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.collectionView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension MovieCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        delegate?.tableMovieCell(didSelectMovie: movie)
    }
}

// MARK: UICollectionViewDelegate
extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / columnsCount
        let height = width * 3 / 2
        return CGSize(width: width, height: height)
    }
}
