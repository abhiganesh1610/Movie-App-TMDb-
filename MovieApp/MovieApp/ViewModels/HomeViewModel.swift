//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//


import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var searchText: String = ""

    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false

    func load(reset: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            currentPage = 1
            totalPages = 1
            movies.removeAll()
        }

        do {
            let response = try await APIClient.shared.fetchPopularMovies(page: currentPage)
            movies.append(contentsOf: response)
            currentPage += 1
        } catch {
            print("Load error:", error)
        }

        isLoading = false
    }

    func loadNextPageIfNeeded(currentMovie movie: Movie) async {
        guard let last = movies.last else { return }
        guard movie.id == last.id else { return }
//        guard currentPage <= totalPages else { return }
        guard searchText.isEmpty else { return }

        await load()
    }

    func search() async {
        guard !searchText.isEmpty else {
            await load(reset: true)
            return
        }

        do {
            let response = try await APIClient.shared.searchMovies(query: searchText, page: currentPage)
            movies = response
        } catch {
            print("Search error:", error)
        }
    }
}
