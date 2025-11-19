//
//  WeekXPView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct WeekXPView: View {
    let color: Color
    let xps = [30, 15, 20, 5, 25, 23, 26]
    
    var body: some View {
        let maxColumnHeight = 120;
        let maxXP = xps.max()!;
        
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 5) {
                ForEach(Array(xps.enumerated()), id: \.offset) {id, xp in
                    let height: CGFloat = maxXP > 0 ? (CGFloat(xp) / CGFloat(maxXP)) * CGFloat(maxColumnHeight) : 0
                    
                    VStack {
                        Text("\(xp) XP")
                            .foregroundColor(color)
                            .shadow(color: .black, radius: 0.15, x: 0, y: 0)
                            .font(.system(size: 10))

                        RoundedRectangle(cornerRadius: 1)
                            .fill(color)
                            .frame(width: 12, height: height)

                        Text("\(24 + id) Авг")
                            .font(.system(size: 10))
                            .foregroundColor(.black)
                    }
                    .frame(width: 40)
                }
            }
            RoundedRectangle(cornerRadius: 1)
                .fill(.black)
                .frame(height: 4)
                .offset(y: -16)
                .padding(.horizontal, 24)
        }
    }
}

#Preview {
    WeekXPView(color: .brown)
}
