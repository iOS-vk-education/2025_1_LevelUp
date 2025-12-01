//
//  ProfileView.swift
//  LevelUp
//
//  Created by dimss on 12/11/2025.
//

import SwiftUI


struct ProfileView: View {
    let maxProfileWidth: CGFloat = 200;
    
    @ObservedObject var stats: Statistics = .shared
    @ObservedObject var achievements = AchievementsStorage.shared
    
    var body: some View {
        ZStack {
            Color.init(hex: 0xe2e2e6)
                .ignoresSafeArea()

            ScrollView {
                header
                
                Image("Profile")
                    .resizable()
                    .frame(
                        maxWidth: maxProfileWidth,
                        maxHeight: maxProfileWidth)
                    .clipShape(Circle())
                
                let info = stats.getLevelInfo()
                ProgressBarView(current: info.currentLevelXP, maximum: info.nextLevelXP, level: info.level)
                    .padding(.bottom, 8)
                
                let completed = achievements.achs.count { ach in ach.isCompleted }
                Text("Выполненно \(completed) из \(achievements.achs.count) достижений")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(achievements.achs) { achievement in
                        AchievementView(achievement: achievement)
                    }
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue.opacity(0.2))
                        .overlay(.thinMaterial)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var header: some View {
        Text("Профиль")
            .font(.system(size: 32, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundStyle(.primary)
    }
}

#Preview {
    ProfileView()
}
