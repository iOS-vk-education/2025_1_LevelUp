//
//  AuthView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        ZStack {
            GradientBackground()
                .ignoresSafeArea()

            VStack(spacing: UIConstants.Spacing.medium) {
                AuthHeaderView()
                AuthButtonsView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AuthView()
    }
}

