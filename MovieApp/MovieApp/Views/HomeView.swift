//
//  HomeView.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//

import SwiftUI


struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10){
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(vm.movies.enumerated()), id: \.element.id) { index, movie in
                            NavigationLink {
                                MovieDetailView(movieId: movie.id)
                            } label: {
                                MovieGridItemView(movie: movie, index: index)
                                    .foregroundColor(.primary)
                            }
                            .onAppear {
                                Task {
                                    await vm.loadNextPageIfNeeded(currentMovie: movie)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if vm.movies.count > 0 && vm.searchText.isEmpty {
                        ProgressView()
                            .padding()
                    }
                }
                .refreshable {
                    await vm.load(reset: true)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Popular Movies")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
                .toolbarTitleDisplayMode(.inline)
                .searchable(text: $vm.searchText)
                .onChange(of: vm.searchText) { 
                    Task { await vm.search() }
                }
            }
        }
        .task {
            await vm.load(reset: true)
        }
    }
}
