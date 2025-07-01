//
//  MovieCategory.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import Foundation

enum MovieCategory: String, CaseIterable {
    case popular = "popular"
    case topRated = "top_rated"
    case nowPlaying = "now_playing"
    case upcoming = "upcoming"
    
    var title: String {
        switch self {
        case .popular: return "Популярные"
        case .topRated: return "Лучшие по рейтингу"
        case .nowPlaying: return "Cейчаст в кино"
        case .upcoming: return "Скоро выйдут"
        }
    }
    
    var endpoint: String {
        return "/movie/\(self.rawValue)"
    }
}
