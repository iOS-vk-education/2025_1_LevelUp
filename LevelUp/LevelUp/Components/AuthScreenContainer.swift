//
//  AuthScreenContainer.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct AuthScreenContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.medium) {
                content
            }
        }
        .background(GradientBackground())
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    NavigationStack {
        AuthScreenContainer {
            Text("Content")
        }
    }
}

