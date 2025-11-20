//
//  Fonts.swift
//  LevelUp
//
//  Created by dimss on 19/11/2025.
//

import SwiftUI

extension Text {
    func bodyText() -> some View {
        self.font(.system(size: 20))
    }
    
    func titleText() -> some View {
        self.font(.system(size: 20, weight: .semibold))
    }
    
    func hiddenText() -> some View {
        self.font(.system(size: 10)).foregroundColor(.secondary)
    }
}
