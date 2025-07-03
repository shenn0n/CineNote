//
//  SearchTableViewController.swift
//  CineNote
//
//  Created by Александр Манжосов on 02.07.2025.
//

import UIKit

class SearchTableViewController: UITableViewController {
    private let networkManager = NetworkManager.shared
    private var movies: [Movie] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var debounceWorkItem: DispatchWorkItem? // для дебаунс ввода
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Популярные запросы"
        tableView.separatorStyle = .none
        fetchTrendingMovies()
        setupSearchController()
    }
    
    private func fetchTrendingMovies() {
        networkManager.fetchTrendingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    
    private func searchMovies(query: String) {
        NetworkManager.shared.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.tableView.reloadData()
            case .failure(let error):
                print("Ошибка поиска: \(error)")
            }
            
        }
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите название фильма"
        searchController.searchBar.barStyle = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchMovieCell", for: indexPath)
        guard let cell = cell as? SearchTableViewCell else { return UITableViewCell() }

        let movie = movies[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: movie)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController else {
            return
        }

        detailsVC.setMovie(selectedMovie)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

//debounce
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        if query.isEmpty {
            title = "Популярные запросы"
            fetchTrendingMovies()
            return
        }
        
        // Отменяем предыдущую задачу, если она ещё не выполнилась
        debounceWorkItem?.cancel()
        
        // Создаём новую задачу с задержкой
        let task = DispatchWorkItem { [weak self] in
            self?.searchMovies(query: query)
        }
        
        debounceWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task) // задержка 0.5 сек
        title = "Поиск"
    }
}
