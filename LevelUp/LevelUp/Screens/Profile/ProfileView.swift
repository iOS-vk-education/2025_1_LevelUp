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
                
                let info = viewModel.getLevelInfo()
                ProgressBarView(current: info.currentLevelXP, maximum: info.nextLevelXP, level: info.level)
                    .padding(.bottom, 8)
                
                Text("Выполненно \(viewModel.nCurrentAchs) из \(viewModel.nTotalAchs) достижений")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(AchievementsStorage.shared.achs) { achievement in
                        AchievementView(achievement: achievement)
                        Divider()
                    }
                }
                .padding(16)
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
