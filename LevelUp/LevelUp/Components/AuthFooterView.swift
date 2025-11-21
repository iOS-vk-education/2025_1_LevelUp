//
//  AuthFooterView.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct AuthFooterView: View {
    let questionText: String
    let linkText: String
    let destination: AnyView
    
    init(questionText: String, linkText: String, destination: () -> some View) {
        self.questionText = questionText
        self.linkText = linkText
        self.destination = AnyView(destination())
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(questionText)
                .font(UIConstants.Fonts.caption)
                .foregroundColor(UIConstants.Colors.textBlack)
            
            NavigationLink(destination: destination) {
                Text(linkText)
                    .font(UIConstants.Fonts.caption)
                    .foregroundColor(UIConstants.Colors.textBlue)
            }
        }
        .padding(.top, UIConstants.Spacing.medium)
        .padding(.bottom, UIConstants.Spacing.bottomPadding)
    }
}

#Preview {
    NavigationStack {
        AuthFooterView(
            questionText: "Все еще нет аккаунта?",
            linkText: "Зарегистрироваться"
        ) {
            Text("Register")
        }
    }
}

