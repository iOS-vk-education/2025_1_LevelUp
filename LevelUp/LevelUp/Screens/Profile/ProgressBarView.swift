//
//  ProgressBar.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct ProgressBarView: View {
    let current: Int
    let maximum: Int
    let icon: Image
    let color: Color
    let description: String
    
    var body: some View {
        let progressWidth = 147 * CGFloat(current) / CGFloat(maximum)
        
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                icon
                    .frame(width: 18, height: 18)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 147, height: 10)
                    .overlay(alignment: .topLeading) {
                        UnevenRoundedRectangle(cornerRadii: .init(
                            topLeading: 4,
                            bottomLeading: 4,
                        ))
                        .fill(color)
                        .frame(width: progressWidth, height: 10)
                    }
            }
            HStack {
                Text("\(current) / \(maximum)")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Spacer()
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .frame(width: 147)
            .padding(.leading, 24)
        }
    }
}



#Preview {
    ProgressBarView(
        current: 40,
        maximum: 100,
        icon: Image("physicalEnergy"),
        color: .brown,
        description: "Физическа энергия",
    )
}
