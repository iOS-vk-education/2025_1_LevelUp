//
//  WeekXPView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct WeekXPView: View {
    let xps = [30, 15, 20, 5, 25, 23, 26]
    
    var body: some View {
        let maxColumnHeight = 120;
        let maxXP = xps.max()!;
        
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 21) {
                ForEach(Array(xps.enumerated()), id: \.offset) {id, xp in
                    let height: CGFloat = maxXP > 0 ? (CGFloat(xp) / CGFloat(maxXP)) * CGFloat(maxColumnHeight) : 0
                    
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.green)
                        .frame(width: 12, height: height)
                        .overlay(alignment: .top) {
                            Text("\(xp) XP")
                                .font(.system(size: 10))
                                .foregroundColor(.green)
                                .fixedSize()
                                .offset(y: -18)
                        }
                        .overlay(alignment: .bottom) {
                            Text("\(24 + id) Авг")
                                .font(.system(size: 10))
                                .foregroundColor(.black)
                                .fixedSize()
                                .offset(y: id % 2 == 0 ? 20 : 34)
                        }
                }
            }
            RoundedRectangle(cornerRadius: 1)
                .fill(.black)
                .frame(width: 270, height: 4)
        }
    }
}

#Preview {
    WeekXPView()
}
