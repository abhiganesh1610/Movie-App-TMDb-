//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//

import SwiftUI
import YouTubePlayerKit

struct MovieDetailView: View {
    
    let movieId: Int
    @StateObject private var vm = MovieDetailViewModel()
    @ObservedObject var favorites = FavoritesManager.shared
    
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment: .leading,spacing: 8){
                    
                    if let key = vm.trailerKey {
                        YouTubePlayerView(
                            YouTubePlayer(
                                source: .video(id: key),
                                configuration: .init()
                            )
                        ) { state in
                            switch state {
                            case .idle:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .scaleEffect(1)
                                    .frame(maxWidth: .infinity,maxHeight: 220)
                                    .background(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .ready:
                                EmptyView()
                            case .error(let error):
                                Text("Trailer failed: \(error.localizedDescription)")
                                    .frame(height: 220)
                            }
                        }
                        .frame(height: 220)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top,10)
                    }
                    
                    if let m = vm.detail {
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack(alignment: .firstTextBaseline){
                                HStack {
                                    Image(systemName: "star.fill")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .opacity(0.8)
                                    Text("\(m.voteAverage ?? 0.0, specifier: "%.1f")/10")
                                        .fontWeight(.bold)
                                }.font(.title3)
                                
                                Text("(\(m.voteCount?.compactVotes ?? "") votes)")
                                    .font(.footnote)
                                
                            }
                            
                            HStack(spacing: 0){
                                Text("\(m.runtime?.hoursAndMinutes ?? "") • ")
                                Text("\(m.genres?.compactMap { $0.name }.joined(separator: ", ") ?? "") • ")
                                Text("\(m.releaseDate?.formattedDate ?? "")")
                            }
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            
                            Text(m.overview ?? "")
                                .font(.system(size: 14))
                                .lineSpacing(3)
                                .padding(.top,8)
                        }
                        .padding()
                    }
                    
                    if let c = vm.castandcrew {
                        if !c.cast.isEmpty {
                            Text("Cast")
                                .font(.headline)
                                .bold()
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top,spacing: 10) {
                                    ForEach(Array(c.cast.enumerated()), id: \.element.id) { index, cast in
                                        ProfileCardView(name: cast.name,
                                                        department: cast.knownForDepartment,
                                                        imagePath: cast.profilePath,index: index)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        if !c.crew.isEmpty {
                            Text("Crew")
                                .font(.headline)
                                .bold()
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top,spacing: 10) {
                                    ForEach(Array(c.crew.enumerated()), id: \.element.id) { index, crew in
                                        ProfileCardView(name: crew.name,
                                                        department: crew.knownForDepartment,
                                                        imagePath: crew.profilePath,index: index)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(1)
            }
        }
        .navigationTitle(vm.detail?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button {
            favorites.toggle(id: movieId)
        } label: {
            Image(systemName: favorites.isFavorite(id: movieId) ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .font(.headline)
        }
        )
        .task {
            isLoading = true
            do {
                try await vm.load(movieId: movieId) {
                    isLoading = false
                }
            } catch {
                isLoading = false
                print("Failed to load movie details: \(error)")
            }
        }
    }
}




struct ProfileCardView: View {
    
    let name: String
    let department: String?
    let imagePath: String?
    let index: Int
    
    let baseURL = "https://image.tmdb.org/t/p/w200"
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            if let path = imagePath, let url = URL(string: baseURL + path) {
                CachedImage(
                    url: url,
                    width: 90,
                    height: 90,
                    shape: .circle
                )
                .animation(
                    .easeOut(duration: 0.30).delay(Double(index) * 0.10),
                    value: index
                )
            }else{
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 90, height: 90)
            }
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .frame(width: 120)
            
            if let dept = department {
                Text(dept)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
            }
        }
    }
}

