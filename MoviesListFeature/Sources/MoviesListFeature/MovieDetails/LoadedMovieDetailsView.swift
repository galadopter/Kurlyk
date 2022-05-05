//
//  SwiftUIView.swift
//  
//
//  Created by Yan Schneider on 04/05/2022.
//

import SwiftUI
import DesignSystem

struct LoadedMovieDetailsView: View {
    let movie: MovieDetails
    
    var body: some View {
        VStack(spacing: Theme.default.sizes.xxl) {
            VStack(spacing: Theme.default.sizes.md) {
                poster
                title
            }.padding(.horizontal, Theme.default.sizes.md)
            HStack {
                overview
                Spacer()
            }.padding(.horizontal, Theme.default.sizes.xl)
            Spacer()
        }.padding(.top, Theme.default.sizes.xl)
    }
}

// MARK: - Components
private extension LoadedMovieDetailsView {
    
    var poster: some View {
        AsyncImage(
            url: movie.posterURL,
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: Constants.posterWidth, maxHeight: Constants.posterHeight)
            },
            placeholder: {
                ProgressView()
                    .tint(Theme.default.colors.text.secondary.swiftUIColor)
            }
        )
    }
    
    var title: some View {
        Text(movie.title)
            .font(Theme.default.fonts.defaultFont(.title, .bold))
            .foregroundColor(Theme.default.colors.text.secondary)
    }
    
    var overview: some View {
        VStack(alignment: .leading, spacing: Theme.default.sizes.md) {
            Text("Overview")
                .font(Theme.default.fonts.defaultFont(.title3, .bold))
                .foregroundColor(Theme.default.colors.text.secondary)
            Text(movie.overview)
                .font(Theme.default.fonts.defaultFont(.body, .regular))
                .foregroundColor(Theme.default.colors.text.secondary)
        }
    }
}

// MARK: - Helpers
private extension LoadedMovieDetailsView {
    
    enum Constants {
        static let posterWidth: CGFloat = 135
        static let posterHeight: CGFloat = 201
    }
}

struct LoadedMovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadedMovieDetailsView(
            movie: .init(
                title: "Blade Runner",
                posterURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!,
                overview: "Awesome movie",
                releaseDate: "June 25, 1982"
            )
        )
    }
}
