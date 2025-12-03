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
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(achievement.tint.opacity(0.15))
                    .frame(width: 55, height: 55)

                let iconColor = achievement.isCompleted ? achievement.tint : Color.gray
                achievement.icon
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(achievement.description)
                    .hiddenText()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.green.opacity(0.15))
                        .frame(height: 16)
                    
                    GeometryReader { geo in
                        let percent = achievement.isCompleted ? 1.0 :
                        Double(achievement.currentScore) / Double(achievement.goal)
                        let width: CGFloat = CGFloat(percent) * geo.size.width
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.green)
                            .frame(width: max(0, width), height: 16)
                    }
                    .frame(height: 16)
                    
                    let barText = achievement.isCompleted ?
                        "Выполнено" :
                        "\(achievement.currentScore) / \(achievement.goal)"
                    Text(barText)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: 200)
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.brown.opacity(0.15))
                    .strokeBorder(.black, lineWidth: 2)
                if achievement.isCompleted {
                    Text(ruDateFormat(achievement.achievedOn!))
                            .hiddenText()
                } else {
                    Text("\(achievement.wage)\nxp")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            .frame(width: 55, height: 55)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            achievement.recalculate()
        }
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible())]) {
            ForEach(AchievementsStorage.shared.achs) { achievement in
                AchievementView(achievement: achievement)
                Divider()
            }
        }
    }
    .padding(16)
    
}
