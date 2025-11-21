//
//  AuthHeaderView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            Spacer()
                .frame(height: 41)
            
            Image("MainAuth")
            
            Text("Добро пожаловать в LevelUp")
                .font(UIConstants.Fonts.title)
                .multilineTextAlignment(.center)
            
            Text("Ставь цели. Строй привычки. Копи опыт.")
                .font(UIConstants.Fonts.body)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    AuthHeaderView()
}

