//
//  ProfileView.swift
//  LevelUp
//
//  Created by dimss on 12/11/2025.
//

import SwiftUI


struct ProfileView: View {
    let maxProfileWidth: CGFloat = 200;
    
    @State var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            Color.init(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    header
                    
                    Image("Profile")
                        .resizable()
                        .frame(
                            maxWidth: maxProfileWidth,
                            maxHeight: maxProfileWidth)
                        .clipShape(Circle())
                    
                    let info = viewModel.getLevelInfo()
                    ProgressBarView(current: info.currentLevelXP, maximum: info.nextLevelXP, level: info.level)
                        .padding(.bottom, 8)
                    
                    Text("Выполненно \(viewModel.nCurrentAchs) из \(viewModel.nTotalAchs) достижений")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    VStack {
                        ForEach(AchievementsStorage.shared.achs) { achievement in
                            AchievementView(achievement: achievement)
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
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
