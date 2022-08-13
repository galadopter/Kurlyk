//
//  SwiftUIView.swift
//  
//
//  Created by Yan Schneider on 11/08/2022.
//

import SwiftUI
import Domain
import DesignSystem

struct FavoriteMovieRow: View {
    let movie: FavoriteMovie
    
    var body: some View {
        HStack {
            title
            Spacer()
            poster
        }.padding(.horizontal, 16)
        .frame(height: 40)
        .transition(.move(edge: .leading))
    }
}

// MARK: - Components
private extension FavoriteMovieRow {
    
    var title: some View {
        Text(movie.title)
            .font(Theme.default.fonts.defaultFont(.headline, .bold))
            .foregroundColor(Theme.default.colors.text.secondary)
    }
    
    var poster: some View {
        AsyncImage(
            url: movie.posterURL,
            transaction: Transaction(animation: .default),
            content: { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            maxWidth: Constants.posterWidth,
                            maxHeight: Constants.posterHeight
                        )
                default:
                    Color.clear
                }
            }
        )
        .transition(.move(edge: .leading))
    }
}

// MARK: - Helpers
private extension FavoriteMovieRow {
    
    enum Constants {
        static let posterWidth: CGFloat = 40
        static let posterHeight: CGFloat = 60
    }
}

struct FavoriteMovieRow_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMovieRow(
            movie: .init(
                id: "",
                title: "Blade Runner",
                posterURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
            )
        )
    }
}
