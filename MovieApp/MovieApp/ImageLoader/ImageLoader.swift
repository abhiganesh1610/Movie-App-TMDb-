//
//  ImageLoader.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//


import SwiftUI
import Foundation
import Combine

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private static let cache = URLCache(
        memoryCapacity: 50 * 1024 * 1024,
        diskCapacity: 200 * 1024 * 1024,
        diskPath: "image-cache"
    )

    func load(from url: URL) {
        let request = URLRequest(url: url)

        if let cached = ImageLoader.cache.cachedResponse(for: request),
           let img = UIImage(data: cached.data) {
            self.image = img
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data,
                  let response = response,
                  let img = UIImage(data: data) else { return }

            let cachedData = CachedURLResponse(response: response, data: data)
            ImageLoader.cache.storeCachedResponse(cachedData, for: request)

            DispatchQueue.main.async {
                self.image = img
            }
        }.resume()
    }
}




enum CachedImageShape {
    case rectangle(cornerRadius: CGFloat)
    case circle
}

struct CachedImage: View {
    let url: URL?
    let width: CGFloat?
    let height: CGFloat
    let shape: CachedImageShape

    @StateObject private var loader = ImageLoader()
    @State private var isVisible = false

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(isVisible ? 1 : 0.96)
                    .animation(.easeOut(duration: 0.35), value: isVisible)
                    .onAppear { isVisible = true }
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .frame(width: width, height: height)
        .applyShape(shape)
        .onAppear {
            guard let url else { return }
            loader.load(from: url)
        }
    }
}

extension View {
    @ViewBuilder
    func applyShape(_ shape: CachedImageShape) -> some View {
        switch shape {
        case .rectangle(let radius):
            self
                .clipped()
                .cornerRadius(radius)

        case .circle:
            self
                .clipShape(Circle())
        }
    }
}


