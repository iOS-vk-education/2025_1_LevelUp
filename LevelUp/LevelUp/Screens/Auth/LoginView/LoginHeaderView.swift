//
//  LoginHeaderView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct LoginHeaderView: View {
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            Image("KnightCharacter")
                .resizable()
                .scaledToFit()
                .frame(height: UIConstants.Sizes.characterImageHeight)
                .padding(.top, UIConstants.Spacing.large)
            
            Text("Войди в свой LevelUp")
                .font(UIConstants.Fonts.title)
                .foregroundColor(UIConstants.Colors.textBlack)
                .multilineTextAlignment(.center)

            Text("С возвращением, герой")
                .font(UIConstants.Fonts.body)
                .foregroundColor(UIConstants.Colors.textBlack)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    LoginHeaderView()
}

