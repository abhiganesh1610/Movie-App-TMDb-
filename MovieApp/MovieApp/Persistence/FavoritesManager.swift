//
//  FavoritesManager.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//

import SwiftUI
import Combine


final class FavoritesManager: ObservableObject {

    static let shared = FavoritesManager()
    @Published private(set) var favorites: Set<Int> = []
    private let key = "favorites"

    private init() {
        load()
    }

    private func load() {
        let saved = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        favorites = Set(saved)
    }

    func toggle(id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        UserDefaults.standard.set(Array(favorites), forKey: key)
    }

    func isFavorite(id: Int) -> Bool {
        favorites.contains(id)
    }
}
