//
//  StarsView.swift
//  LevelUp
//
//  Created by dimss on 13/11/2025.
//

import SwiftUI

struct StarView : View {
    let completed: Bool
    
    var body: some View {
        Image(systemName: "star.fill").foregroundColor(completed ? .yellow : .gray)
    }
}

func getStarsArr(completed: Int, total: Int) -> [some View] {
    (0..<total).map { i in
        StarView(completed: i < completed)
    }
}

struct TwoStarsView: View {
    let completed: Int
    
    var body: some View {
        let stars = getStarsArr(completed: completed, total: 2)
        HStack(spacing: 0) {
            stars[0]
            stars[1]
        }
    }
}

struct ThreeStarsView: View {
    let completed: Int
    
    var body: some View {
        let stars = getStarsArr(completed: completed, total: 3)
        HStack(spacing: -10) {
            stars[0].offset(y: +7)
            stars[1].offset(y: -8)
            stars[2].offset(y: +7)
        }
    }
}

struct FourStarsView: View {
    let completed: Int
    
    var body: some View {
        let stars = getStarsArr(completed: completed, total: 4)
        VStack {
            HStack(spacing: 0) {
                stars[1]
                stars[2]
            }
            HStack(spacing: 0) {
                stars[0]
                stars[3]
            }
        }
    }
}

struct FifeStarsView: View {
    let completed: Int
    
    var body: some View {
        let stars = getStarsArr(completed: completed, total: 5)
        HStack(spacing: -10) {
            stars[0].offset(y: +7)
            stars[1].offset(y: -8)
            stars[2].offset(y: +7)
            stars[3].offset(y: -8)
            stars[4].offset(y: +7)
        }
    }
}


public struct StarsView: View {
    let completed: Int
    let total: Int
    
    public var body: some View {
        switch total {
        case 1: StarView(completed: completed > 0)
        case 2: TwoStarsView(completed: completed)
        case 3: ThreeStarsView(completed: completed)
        case 4: FourStarsView(completed: completed)
        case 5: FifeStarsView(completed: completed)
        default: EmptyView()
        }
    }
}



#Preview {
    StarsView(completed: 3, total: 4)
}
