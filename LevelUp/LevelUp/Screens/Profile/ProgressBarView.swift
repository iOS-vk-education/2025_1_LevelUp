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
    let level: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Level \(level)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(4)

            let height = 10 as CGFloat
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gradientSecond)
                    .frame(height: height - 2)
                    .overlay(alignment: .leading) {
                        let progressWidth = geo.size.width * CGFloat(current) / CGFloat(maximum)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.blue)
                            .frame(width: progressWidth, height: height)
                    }
            }
            .frame(height: height)
            
            Text("\(current) / \(maximum)")
                .hiddenText()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}



#Preview {
    ProgressBarView(
        current: 40,
        maximum: 100,
        level: 11,
    )
    .padding(16)
}
