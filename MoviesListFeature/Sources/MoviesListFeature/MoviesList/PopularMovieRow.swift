//
//  PopularMovieRow.swift
//  
//
//  Created by Yan Schneider on 28/04/2022.
//

import SwiftUI
import DesignSystem

struct PopularMovieRow: View {
    let movie: PopularMovie
    
    var body: some View {
        ZStack {
            Theme.default.colors.background.swiftUIColor
            HStack(spacing: 18) {
                poster
                VStack {
                    title
                    subtitle
                }
                Spacer()
                ratingView
            }.padding()
        }
    }
}

// MARK: - Components
private extension PopularMovieRow {
    
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
            .font(Theme.default.fonts.defaultFont(.headline, .bold))
            .foregroundColor(Theme.default.colors.text.secondary)
    }
    
    var subtitle: some View {
        Text(movie.releaseDate)
            .font(Theme.default.fonts.defaultFont(.body, .regular))
            .foregroundColor(Theme.default.colors.text.secondary)
    }
    
    var ratingView: some View {
        RatingView(rating: movie.rating)
            .frame(width: Constants.ratingViewSide, height: Constants.ratingViewSide)
    }
}

// MARK: - Helpers
private extension PopularMovieRow {
    enum Constants {
        static let ratingViewSide: CGFloat = 60
        static let posterWidth: CGFloat = 49
        static let posterHeight: CGFloat = 73
    }
}

struct PopularMovieRow_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovieRow(movie: .init(
            id: "1", title: "Blade Runner",
            releaseDate: "June 25, 1982", rating: 0.95,
            posterURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
        ))
    }
}
