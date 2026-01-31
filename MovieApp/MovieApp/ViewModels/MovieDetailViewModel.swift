//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//


import SwiftUI
import Combine

@MainActor
final class MovieDetailViewModel: ObservableObject {

    @Published var detail: MovieDetail?
    @Published var castandcrew : MovieCredits?
    @Published var trailerKey: String?

    func load(movieId: Int, completion handler: () -> Void) async throws {
        async let d = try APIClient.shared.fetchMovieDetail(id: movieId)
        async let c = try APIClient.shared.fetchCredits(id: movieId)
        async let t = try APIClient.shared.fetchTrailer(id: movieId)

        let (detailResult, castResult, trailerKeyResult) = try await (d, c, t)
        detail = detailResult
        castandcrew = castResult
        trailerKey = trailerKeyResult
        
        handler()
    }
}

