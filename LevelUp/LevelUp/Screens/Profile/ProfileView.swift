//
//  ProfileView.swift
//  LevelUp
//
//  Created by dimss on 12/11/2025.
//

import SwiftUI

struct ProfileView: View {
    let name = "Луффи"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack {
                        Image("Profile")
                            .resizable()
                            .frame(
                                width: ProfileViewSizes.iconSize.rawValue,
                                height: ProfileViewSizes.iconSize.rawValue)
                            .clipShape(Circle())
                        
                        HStack {
                            HStack(spacing: 4) {
                                Text("11")
                                Image(systemName: "wind.snow")
                                    .foregroundStyle(.blue, .yellow.opacity(0.4))
                            }
                            HStack(spacing: 4) {
                                Text("7")
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    VStack(spacing: 11) {
                        ProgressBarView(
                            current: 40,
                            maximum: 100,
                            icon: Image("energy"),
                            mainColor: .yellow,
                            secondaryColor: .yellow.opacity(0.3),
                            description: "Энергия"
                        )
                        ProgressBarView(
                            current: 40,
                            maximum: 100,
                            icon: Image("physicalEnergy"),
                            mainColor: .brown,
                            secondaryColor: .brown.opacity(0.3),
                            description: "Физическа энергия",
                        )
                        ProgressBarView(
                            current: 40,
                            maximum: 100,
                            icon: Image("expirience"),
                            mainColor: .green,
                            secondaryColor: .green.opacity(0.3),
                            description: "Опыт"
                        )
                    }
                }
                
                HStack {
                    Image("cup")
                        .frame(
                            width: ProfileViewSizes.cupSize.rawValue,
                            height: ProfileViewSizes.cupSize.rawValue)
                    Text("12")
                        .font(.system(size: 32))
                    Spacer()
                    Text("Достижения")
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AcheevementBackgroundView())
                
                Text("Набранный опыт за последнюю неделю")
                    .font(.system(size: 20))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: ProfileViewSizes.statisticsMaxWidth.rawValue)
                WeekXPView(color: .green)
                
                
                Text("Потрачено энергии за последнюю неделю")
                    .font(.system(size: 20))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(width: ProfileViewSizes.statisticsMaxWidth.rawValue)
                
                WeekXPView(color: .yellow)
                
                Text("Потрачено физической энергии за последнюю неделю")
                    .font(.system(size: 20))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(width: ProfileViewSizes.statisticsMaxWidth.rawValue)
                
                WeekXPView(color: .brown)
            }
            .padding(.horizontal, 16)
        }

        Spacer()
        
        TabView {
            Tab("Задачи", systemImage: "target") {
                
            }
            Tab("Профиль", systemImage: "person.crop.circle") {
                ProfileView()
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    ProfileView()
}
