//
//  ProfileViewModel.swift
//  LevelUp
//
//  Created by dimss on 03/12/2025.
//

import SwiftUI

@Observable
final class ProfileViewModel {
    private var achievements = AchievementsStorage.shared
    private var statistics = Statistics.shared
    
    var nCurrentAchs: Int {
        AchievementsStorage.shared.nCompleted
    }
    
    var nTotalAchs: Int {
        achievements.achs.count
    }
    
    func getLevel() -> Int {
        getLevelInfo().level
    }
    
    func getLevelInfo() -> LevelInfo {
        statistics.getLevelInfo()
    }
}
