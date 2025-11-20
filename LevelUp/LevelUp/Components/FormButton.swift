//
//  FormButton.swift
//  LevelUp
//
//  Created by Ilya Ermakov on 11/19/25.
//

import SwiftUI

struct FormButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        PrimaryButton(title: title, action: action)
            .padding(.horizontal, UIConstants.Spacing.large)
            .padding(.top, UIConstants.Spacing.formSpacing)
    }
}

#Preview {
    FormButton(title: "Войти") {
        print("Tapped")
    }
}

