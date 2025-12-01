//
//  AchievementView.swift
//  LevelUp
//
//  Created by dimss on 24/11/2025.
//

import SwiftUI

struct AchievementView: View {
    @ObservedObject
    var achievement: Achievement

    var body: some View {
        let icon = achievement.isCompleted ?
            Image(systemName: "medal.fill").foregroundColor(.yellow) :
            Image(systemName: "medal.fill").foregroundColor(.gray)
        let shape = RoundedRectangle(cornerRadius: 20)

        VStack {
            Text(achievement.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .overlay(alignment: .leading) {
                    icon.frame(alignment: .leading)
                }
            Text(achievement.description)
                .hiddenText()
                .multilineTextAlignment(.center)
        }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 100)
            .glassEffect(
                .regular.tint(.blue.opacity(0.2)).interactive(),
                in: shape)
            .background(
                Color(hex: 0xe2c6fb)
                    .clipShape(shape)
            )
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        ForEach(AchievementsStorage.shared.achs) { achievement in
            AchievementView(achievement: achievement)
        }
    }
    .padding(32)
    
}
