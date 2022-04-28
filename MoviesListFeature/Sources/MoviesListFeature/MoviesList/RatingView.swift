//
//  RatingView.swift
//  
//
//  Created by Yan Schneider on 28/04/2022.
//

import SwiftUI
import DesignSystem

struct RatingView: View {
    let rating: Double
    
    // State is used to animate the circle in the beginning
    @State private var ratingCircleEnd: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                circleBackground(viewWidth: geometry.size.width)
                ratingCircle(viewWidth: geometry.size.width)
                ratingText
            }
        }.onAppear {
            withAnimation(.linear(duration: 0.5)) {
                ratingCircleEnd = CGFloat(min(rating, 1))
            }
        }
    }
}

// MARK: - Components
private extension RatingView {
    
    func circleBackground(viewWidth: CGFloat) -> some View {
        Circle()
            .stroke(lineWidth: viewWidth / Constants.capScaleFactor)
            .opacity(0.3)
            .foregroundColor(circleColor)
    }
    
    func ratingCircle(viewWidth: CGFloat) -> some View {
        Circle()
            .trim(from: 0, to: ratingCircleEnd)
            .stroke(
                style: .init(
                    lineWidth: viewWidth / Constants.capScaleFactor,
                    lineCap: .round, lineJoin: .round
                )
            )
            .foregroundColor(circleColor)
            .rotationEffect(.degrees(270))
    }
    
    var ratingText: some View {
        Text(String(format: "%.0f%%", min(rating, 1) * 100))
            .font(Theme.default.fonts.defaultFont(.headline, .bold))
            .foregroundColor(Theme.default.colors.text.secondary)
    }
}

// MARK: - Helpers
private extension RatingView {
    
    enum Constants {
        static let capScaleFactor: CGFloat = 12
    }
    
    var circleColor: SwiftUI.Color {
        if rating > 0.7 {
            return .green
        } else if rating > 0.5 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 0.2)
            .background(Theme.default.colors.background)
    }
}
