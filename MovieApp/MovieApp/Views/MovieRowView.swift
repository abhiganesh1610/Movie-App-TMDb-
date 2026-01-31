//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//

import SwiftUI

struct MovieGridItemView: View {
    
    let movie: Movie
    let index: Int
    @ObservedObject var favorites = FavoritesManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topTrailing) {
                
                CachedImage(
                    url: URL(string: APIConstants.imageBaseURL + (movie.posterPath ?? "")),
                    width: nil,
                    height: 175,
                    shape: .rectangle(cornerRadius: 10)
                )
                    .animation(
                        .easeOut(duration: 0.35).delay(Double(index) * 0.15),
                        value: movie.id
                    )
                
                Button {
                    favorites.toggle(id: movie.id)
                } label: {
                    Image(systemName: favorites.isFavorite(id: movie.id) ? "heart.fill" : "heart")
                        .bold()
                        .foregroundColor(.red)
                        .font(.title3)
                        .padding(3)
                        .background(
                            Circle()
                                .fill(.secondary.opacity(0.3))
                        )
                }
                .padding(4)
            }
            
            VStack(alignment: .leading,spacing: 4){
                HStack(spacing: 2){
                    Image(systemName: "star.fill")
                        .foregroundColor(.red)
                        .opacity(0.8)
                    Text("\(movie.voteAverage ?? 0.0, specifier: "%.1f")")
                    Spacer()
                    Text("\(movie.voteCount?.compactVotes ?? "")")
                    Text("votes")
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                
                Text(movie.title ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}


