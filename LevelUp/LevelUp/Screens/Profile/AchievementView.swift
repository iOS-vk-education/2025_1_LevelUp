//
//  AchievementView.swift
//  LevelUp
//
//  Created by dimss on 24/11/2025.
//

import SwiftUI

struct GlassTileBackground: View {
    let color: Color
    var cornerRadius: CGFloat = 28

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(0.45),
                        color.opacity(0.25)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            .shadow(color: color.opacity(0.15), radius: 12, x: 0, y: 4)
    }
}



struct AchievementView: View {
    var achievement: Achievement

    var body: some View {
        ZStack {
            GlassTileBackground(color: achievement.isCompleted ? achievement.tint : Color.gray)

            VStack(spacing: 8) {
                achievement.icon
                    .resizable()
                    .scaledToFit()
                    .frame(height: 110)
                    .opacity(achievement.isCompleted ? 1 : 0.4)
                    .padding(.top, 8)

                VStack(spacing: 4) {
                    Text(achievement.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }

                let rawProgress = achievement.isCompleted
                    ? 1.0
                    : (achievement.goal > 0
                       ? Double(achievement.currentScore) / Double(achievement.goal)
                       : 0)
                let progressText = achievement.isCompleted
                    ? "Выполнено"
                    : "\(achievement.currentScore) / \(achievement.goal)"

                Brogress.BarView(
                    progress: rawProgress,
                    height: 14,
                    label: progressText
                )
            }
            .padding(10)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            achievement.recalculate()
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ForEach(AchievementsStorage.shared.achs) { achievement in
                AchievementView(achievement: achievement)
                Divider()
            }
        }
    }
    .padding(16)
    
}
