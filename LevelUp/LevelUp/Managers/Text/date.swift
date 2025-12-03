//
//  date.swift
//  LevelUp
//
//  Created by dimss on 02/12/2025.
//

import Foundation

func ruDateFormat(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "d MMM, yyyyг."
    return formatter.string(from: date)
}
