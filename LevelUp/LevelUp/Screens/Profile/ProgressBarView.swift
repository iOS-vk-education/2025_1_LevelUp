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
    
    var height: CGFloat = 12

    private var progress: Double {
        guard maximum > 0 else { return 0 }
        return Double(current) / Double(maximum)
    }

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        VStack(spacing: 6) {
            Text("Level \(level)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.primary)

            AppProgressView(progress: clampedProgress, height: height)

            if maximum > 0 {
                Text("\(current) / \(maximum)")
                    .hiddenText()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ProgressBarView(current: 20, maximum: 100, level: 11)
        ProgressBarView(current: 60, maximum: 100, level: 12, height: 14)
        ProgressBarView(current: 150, maximum: 100, level: 13)
        ProgressBarView(current: 0, maximum: 0, level: 14)
    }
    .padding(16)
    .background(Color("BachgroundColor"))
}
