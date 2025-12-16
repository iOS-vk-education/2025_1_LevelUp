//
//  RegisterHeaderView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct RegisterHeaderView: View {
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            Image("WinCup")
                .padding(.top, UIConstants.Spacing.topPadding)
            
            HStack(spacing: 4) {
                Text("Начни свой путь")
                    .font(UIConstants.Fonts.title)
                    .foregroundColor(UIConstants.Colors.textBlack)
                Text("🚀")
                    .font(UIConstants.Fonts.title)
            }
            .multilineTextAlignment(.center)
            
            Text("Создай свой аккаунт и зарабатывай опыт за каждую задачу")
                .font(UIConstants.Fonts.body)
                .foregroundColor(UIConstants.Colors.textBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
        }
    }
}

#Preview {
    RegisterHeaderView()
}

