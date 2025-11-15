//
//  InfoNumberView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct InfoNumberView: View {
    let number: String
    let description: String
    let background: Image
    let fontColor: Color
    
    var body: some View {
        ZStack {
            background
                .resizable()
                .frame(width: 80, height: 80)
            
            Text(number)
                .font(.system(size: 20, weight: .semibold))
                .position(x: 40, y: 22)
            
            Text(description)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .frame(width: 80)
                .position(x: 40, y: 47)
        }
        .frame(width: 80, height: 80)
        .foregroundColor(fontColor)
    }
}

#Preview {
    InfoNumberView(number: "7", description: "Дней подряд", background: Image("dayStrike"), fontColor: .indigo)
}
