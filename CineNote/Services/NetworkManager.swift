//
//  NetworkManager.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    func fetchMovies(for category: MovieCategory, completion: @escaping (Result<(MovieCategory, [Movie]), NetworkError>) -> Void) {
        let urlString = "\(Constants.baseURL)\(category.endpoint)?api_key=\(Constants.apiKey)&language=ru-RU"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let dataModel = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success((category, dataModel.results)))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=43f1427a3e06ef8db06790fe1edb2473&language=ru"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(GenreResponse.self, from: data)
                completion(.success(response.genres))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}
