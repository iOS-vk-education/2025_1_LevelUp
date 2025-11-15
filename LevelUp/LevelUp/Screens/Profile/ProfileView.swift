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
        VStack {
            HStack {
                Image("Profile")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Spacer()
                
                VStack(spacing: 2) {
                    ProgressBarView(
                        current: 40,
                        maximum: 100,
                        icon: Image("energy"),
                        color: .yellow,
                        description: "Энергия"
                    )
                    ProgressBarView(
                        current: 40,
                        maximum: 100,
                        icon: Image("physicalEnergy"),
                        color: .brown,
                        description: "Физическа энергия",
                    )
                    ProgressBarView(
                        current: 40,
                        maximum: 100,
                        icon: Image("expirience"),
                        color: .green,
                        description: "Опыт"
                    )
                }
            }
            .padding(.horizontal, 54)
            
            HStack {
                Text(name)
                    .font(.custom("Profile", size: 20))
                Image(systemName: "square.and.pencil")
                    .font(.custom("Profile", size: 20))
                Spacer()
            }
            .padding(.horizontal, 60)
            
            HStack {
                InfoNumberView(number: "11", description: "Level", background: Image("level"), fontColor: .white)
                Spacer()
                InfoNumberView(number: "7", description: "Дней подряд", background: Image("dayStrike"), fontColor: .indigo)
            }
            .padding(.horizontal, 68)

            ZStack {
                AcheevementBackgroundView(height: 87)
                HStack {
                    Text("12").font(.system(size: 20, weight: .semibold))
                    Image("cup")
                        .frame(width: 52, height: 52)
                    Spacer()
                    Text("Достижения").font(Font.system(size: 20, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 23)
                .frame(width: 320)
            }
            
            Text("Активность за последнюю неделю")
                .frame(width: 245)
                .multilineTextAlignment(.center)
                .font(.system(size: 20))
                .padding(.top, 20)
            
            WeekXPView()
                .padding(.top, 42)
            
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
}

#Preview {
    ProfileView()
}
