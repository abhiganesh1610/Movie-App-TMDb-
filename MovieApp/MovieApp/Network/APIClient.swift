//
//  APIClient.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//


import SwiftUI
import Foundation

final class APIClient {

    static let shared = APIClient()
    private init() {}


    private func fetch<T: Codable>(_ url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(statusCode: -1)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
            }

            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch {
            throw error
        }
    }


    // Popular
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        let urlString = "\(APIConstants.baseURL)/movie/popular?api_key=\(APIConstants.apiKey)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: MovieResponse = try await fetch(url)
        return response.results ?? []
    }



    // Search
    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(APIConstants.baseURL)/search/movie?api_key=\(APIConstants.apiKey)&query=\(q)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let response: MovieResponse = try await fetch(url)
        return response.results ?? []
    }


    // Detail
    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let urlString = "\(APIConstants.baseURL)/movie/\(id)?api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        return try await fetch(url)
    }


    // Cast
    func fetchCredits(id: Int) async throws -> MovieCredits {
        let urlString = "\(APIConstants.baseURL)/movie/\(id)/credits?api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        return try await fetch(url)
    }


    // Trailer
    func fetchTrailer(id: Int) async -> String? {
        let urlString = "\(APIConstants.baseURL)/movie/\(id)/videos?api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let response: VideoResponse = try await fetch(url)
            
            guard let results = response.results, !results.isEmpty else {
                return nil
            }

            if let officialTrailer = results.first(where: {
                $0.site?.lowercased() == "youtube" &&
                $0.type?.lowercased() == "trailer" &&
                $0.official == true
            }) {
                return officialTrailer.key
            }

            if let trailer = results.first(where: {
                $0.site?.lowercased() == "youtube" &&
                $0.type?.lowercased() == "trailer"
            }) {
                return trailer.key
            }

            if let clip = results.first(where: {
                $0.site?.lowercased() == "youtube" &&
                $0.type?.lowercased() == "clip"
            }) {
                return clip.key
            }
            return nil

        } catch {
            return nil
        }
    }



}



enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse(let statusCode):
            return "Invalid response from server. Status code: \(statusCode)."
        case .noData:
            return "No data received from server."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
