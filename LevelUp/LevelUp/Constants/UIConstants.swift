//
//  UIConstants.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

enum UIConstants {
    //Spacing
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 40
        static let topPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 40
        static let horizontalPadding: CGFloat = 20
        static let formSpacing: CGFloat = 8
    }
    
    //Sizes
    enum Sizes {
        static let buttonHeight: CGFloat = 54
        static let buttonWidth: CGFloat = 380
        static let characterImageHeight: CGFloat = 200
        static let cornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 16
    }
    
    //Fonts
    enum Fonts {
        static let title: Font = .system(size: 32, weight: .bold)
        static let body: Font = .system(size: 16)
        static let caption: Font = .system(size: 14)
        static let button: Font = .system(size: 16, weight: .semibold)
    }
    
    // Colors
    enum Colors {
        static let backgroundGray = Color.gray.opacity(0.1)
        static let textBlack = Color.black
        static let textGray = Color.gray
        static let textBlue = Color.blue
    }
    
    // Gradient
    static let gradientStops: [Gradient.Stop] = [
        .init(color: Color("GradientFirst"), location: 0.0),
        .init(color: .white, location: 0.33),
        .init(color: .white, location: 0.69),
        .init(color: Color("GradientSecond"), location: 1.0)
    ]
}

