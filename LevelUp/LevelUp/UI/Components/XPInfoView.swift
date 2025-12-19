//
//  XPInfoView.swift
//  LevelUp
//
//  Created by Андрей Прибавкин on 17.12.25.
//
import SwiftUI

struct XPInfoView: View {
    let earnedXP: Int

    var body: some View {
        ZStack {
            Color(red: 0.30, green: 0.60, blue: 0.98)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("mascott")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 360)

                Text("Копи опыт и получай XP")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Text("Текущее XP за сегодня: \(earnedXP)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .multilineTextAlignment(.center)
            .padding(24)
        }
    }
}
