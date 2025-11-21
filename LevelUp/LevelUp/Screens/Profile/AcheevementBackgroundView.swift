//
//  AcheevementBackgroundView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

// todo: customize height for acheevement
struct AcheevementBackgroundView: View {
    var body: some View {
        Image("acheevementBackground")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(-40)  // drop shadow
            
    }
}

#Preview {
    Text("Hello, World!")
        .background(AcheevementBackgroundView())
        .padding()

    ZStack {
        AcheevementBackgroundView()
        Text("Hello, World 2!")
    }
    .padding()
}
