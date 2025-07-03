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
        let urlString = "\(Constants.baseURL)\(category.endpoint)?api_key=\(Constants.apiKey)&language=\(Constants.language)"
        
        performRequest(urlString: urlString) { (result: Result<MovieResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success((category, response.results)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchGenres(completion: @escaping (Result<[Genre], NetworkError>) -> Void) {
        let urlString = "\(Constants.baseURL)/genre/movie/list?api_key=\(Constants.apiKey)&language=\(Constants.language)"
        
        performRequest(urlString: urlString) { (result: Result<GenreResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.apiKey)&query=\(encodedQuery)&language=\(Constants.language)"
        
        performRequest(urlString: urlString) { (result: Result<MovieSearchResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTrendingMovies(completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.apiKey)&language=\(Constants.language)"
        
        performRequest(urlString: urlString) { (result: Result<MovieSearchResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
    
    private func performRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
