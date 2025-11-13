//
//  AcheevementBackgroundView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct AcheevementBackgroundView: View {
    let height: CGFloat
    
    var body: some View {
        Image("acheevementBackground")
            .resizable()
            .scaledToFill()
            .frame(width: 320, height: height)
            .clipped()
            .cornerRadius(10)
    }
}

#Preview {
    ZStack {
        AcheevementBackgroundView(height: 100)
        Text("Hello, World!")
    }
}
