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
    let mainColor: Color
    let secondaryColor: Color
    let description: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            icon
                .frame(
                    width: ProfileViewSizes.barIconSize.rawValue,
                    height: ProfileViewSizes.barIconSize.rawValue)

            VStack(spacing: 4) {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(secondaryColor)
                        .frame(height: 3)
                        .overlay(alignment: .leading) {
                            let progressWidth = geo.size.width * CGFloat(current) / CGFloat(maximum)
                            
                            UnevenRoundedRectangle(cornerRadii: .init(
                                topLeading: 4,
                                bottomLeading: 4,
                            ))
                            .fill(mainColor)
                            .frame(width: progressWidth, height: 4)
                        }
                }
                .frame(height: 4)
                
                HStack {
                    Text("\(current) / \(maximum)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(description)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        
    }
}



#Preview {
    ProgressBarView(
        current: 40,
        maximum: 100,
        icon: Image("physicalEnergy"),
        mainColor: .brown,
        secondaryColor: .brown.opacity(0.3),
        description: "Физическа энергия",
    )
    .padding(16)
}
