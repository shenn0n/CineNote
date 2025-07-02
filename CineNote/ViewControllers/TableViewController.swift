//
//  TableViewController.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import UIKit

final class TableViewController: UITableViewController {
    private let networkManager = NetworkManager.shared
    private let dataSource = MovieDataSource()
    private let categories = MovieCategory.allCases
    private var genres: [Genre] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllCategories()
        //loadGenres()
    }
    
    private func loadAllCategories() {
        for category in categories {
            networkManager.fetchMovies(for: category) { [weak self] movies in
                switch movies {
                case .success(let (category, movies)):
                    self?.dataSource.moviesByCategory[category] = movies
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Ошибка при загрузке \(category): \(error)")
                }
            }
        }
    }
    
    private func loadGenres() {
        networkManager.fetchGenres { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                    self?.genres = genres
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? categories.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath)
            guard let cell = cell as? TableMovieCell else { return UITableViewCell() }
            
            let category = categories[indexPath.row]
            let movies = dataSource.moviesByCategory[category] ?? []
            
            cell.categoryTitleLabel.text = category.title
            cell.movies = movies

            cell.collectionMovieView.setContentOffset(.zero, animated: false) // сброс позиции при переиспользовании
            cell.collectionMovieView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "genreListCell", for: indexPath)
            guard let cell = cell as? TableGenreCell else { return UITableViewCell() }
            
            cell.genres = genres
            cell.collectionGenreView.reloadData()
            return cell
        }
    }
}

