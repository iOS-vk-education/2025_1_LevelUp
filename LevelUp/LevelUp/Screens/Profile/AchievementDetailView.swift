import SwiftUI

struct AchievementDetailView: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss

    private var progress: Double {
        if achievement.isCompleted {
            return 1.0
        }
        guard achievement.goal > 0 else { return 0 }
        return Double(achievement.currentScore) / Double(achievement.goal)
    }

    private var statusText: String {
        if achievement.isCompleted {
            if let date = achievement.achievedOn {
                return "Выполнено \(ruDateFormat(date))"
            } else {
                return "Выполнено"
            }
        } else {
            return "Ещё не выполнено"
        }
    }

    var body: some View {
        let baseColor: Color = achievement.isCompleted ? achievement.tint : .gray

        ZStack {
            LinearGradient(
                colors: [
                    baseColor.opacity(0.35),
                    baseColor.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.9))
                            .padding(6)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.25))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                Spacer(minLength: 12)

                achievement.icon
                    .resizable()
                    .scaledToFit()
                    .frame(height: 320)
                    .padding(.horizontal, 24)
                    .opacity(achievement.isCompleted ? 1 : 0.4)

                Spacer(minLength: 16)

                VStack(alignment: .leading, spacing: 6) {
                    Text(achievement.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)

                    Text(achievement.description)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.black.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                Divider()
                    .background(Color.white.opacity(0.4))
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(statusText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black.opacity(0.7))

                    HStack {
                        Text("\(achievement.currentScore) / \(achievement.goal)")
                        Spacer()
                        Text("\(achievement.wage) XP")
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.black)

                    Brogress.BarView(
                        progress: progress,
                        height: 18,
                        label: nil
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 4)

                Spacer(minLength: 24)
            }
        }
    }
}
