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
                    .frame(height: 64)
                    .opacity(achievement.isCompleted ? 1 : 0.4)
                    .padding(.top, 8)

                VStack(spacing: 4) {
                    Text(achievement.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    Text(achievement.description)
                        .hiddenText()
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                let height: CGFloat = 24
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.green.opacity(0.15))
                        .frame(height: height)

                    GeometryReader { geo in
                        let percent = achievement.isCompleted ? 1.0 :
                        Double(achievement.currentScore) / Double(achievement.goal)
                        let width: CGFloat = CGFloat(percent) * geo.size.width

                        RoundedRectangle(cornerRadius: 8)
                            .fill(.green)
                            .frame(width: max(0, width), height: height)
                    }
                    .frame(height: height)

                    let barText = achievement.isCompleted ?
                        "Выполнено" :
                        "\(achievement.currentScore) / \(achievement.goal)"
                    Text(barText)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.brown.opacity(0.15))
                    if let date = achievement.achievedOn {
                        Text(ruDateFormat(date))
                            .hiddenText()
                            .font(.system(size: 12))
                    } else {
                        Text("\(achievement.wage) xp")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
                .frame(height: height)
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
