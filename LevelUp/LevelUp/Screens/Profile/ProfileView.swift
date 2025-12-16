//
//  ProfileView.swift
//  LevelUp
//
//  Created by dimss on 12/11/2025.
//

import SwiftUI

struct ProfileView: View {
    private let maxProfileWidth: CGFloat = 280

    private let headerHeight: CGFloat = 400

    private let fadeStart: CGFloat = 0
    private let fadeDistance: CGFloat = 140

    private let scaleStart: CGFloat = 0
    private let scaleDistance: CGFloat = 180
    private let minScale: CGFloat = 0.88

    @State private var viewModel = ProfileViewModel()
    @State private var scrollY: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            Color.init(.systemGroupedBackground)
                .ignoresSafeArea()

            headerLayer
                .frame(height: headerHeight)
                .ignoresSafeArea(edges: .top)

            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    scrollTracker
                    Color.clear
                        .frame(height: headerHeight)
                    contentSheet
                }
            }
            .coordinateSpace(name: "scroll")
            .scrollIndicators(.hidden)
        }
    }

    private var scrollTracker: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: ScrollYKey.self,
                            value: geo.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollYKey.self) { scrollY = $0 }
    }

    private struct ScrollYKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }

    private var headerLayer: some View {
        let info = viewModel.getLevelInfo()

        return VStack(spacing: 4) {
            

            Text("Профиль")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(profileTitleOpacity)
                .scaleEffect(profileTitleScale)

            ZStack(alignment: .bottomLeading) {
                Image("profile_pic")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: maxProfileWidth, maxHeight: maxProfileWidth)
                    .opacity(profileImageOpacity)
                    .scaleEffect(profileImageScale)
                    .animation(.easeOut(duration: 0.15), value: scrollY)

                Text("Уровень \(info.level)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.black.opacity(0.35))
                    )
                    .padding(.bottom, 6)
                    .offset(x: -24)
                    .opacity(profileImageOpacity)
                    .scaleEffect(profileImageScale)
                    .animation(.easeOut(duration: 0.15), value: scrollY)

            }

            ProgressBarView(
                current: info.currentLevelXP,
                maximum: info.nextLevelXP,
                level: info.level,
                showTitle: false
            )
            .padding(.horizontal, 16)
            .opacity(profileImageOpacity)
            .scaleEffect(profileImageScale)
            .animation(.easeOut(duration: 0.15), value: scrollY)
        }
        .padding(.horizontal, 16)
        .padding(.top, 78)
        .padding(.bottom, -48)

    }

    private var contentSheet: some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]

        return VStack() {
            Text("Достижения")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
                .padding(.top, 12)
            Text("Выполненно \(viewModel.nCurrentAchs) из \(viewModel.nTotalAchs) достижений")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)

            Button("Добавить 10000 XP") {
                // Добавляем опыт через extraXpWage, чтобы он сохранялся локально и в Firebase.
                Statistics.shared.addExtraWage(10_000)

                // Пересчитываем достижения, завязанные на прогрессе.
                AchievementsStorage.shared.achs.forEach { achievement in
                    achievement.recalculate()
                }

                // Сохраняем прогресс текущего пользователя в Firebase.
                _Concurrency.Task {
                    try? await ProgressService.shared.saveCurrentUserProgress()
                }
            }
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AchievementsStorage.shared.achs) { achievement in
                    AchievementView(achievement: achievement)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }

    private var scrolledUp: CGFloat { max(0, -scrollY) }

    private var profileImageOpacity: CGFloat {
        let x = max(0, scrolledUp - fadeStart)
        let t = 1 - (x / fadeDistance)
        return min(1, max(0, t))
    }

    private var profileImageScale: CGFloat {
        let x = max(0, scrolledUp - scaleStart)
        let t = 1 - (x / scaleDistance) * (1 - minScale)
        return min(1, max(minScale, t))
    }

    private var profileTitleOpacity: CGFloat {
        let x = max(0, scrolledUp - fadeStart)
        let t = 1 - (x / (fadeDistance * 0.9))
        return min(1, max(0, t))
    }

    private var profileTitleScale: CGFloat {
        let x = max(0, scrolledUp - scaleStart)
        let t = 1 - (x / (scaleDistance * 0.9)) * (1 - 0.92)
        return min(1, max(0.92, t))
    }
}

#Preview {
    ProfileView()
}
