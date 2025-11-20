//
//  AuthView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/18/25.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        VStack(spacing: UIConstants.Spacing.medium) {
            AuthHeaderView()
            AuthButtonsView()
        }
        .background(GradientBackground())
    }
}

#Preview {
    NavigationStack {
        AuthView()
    }
}

