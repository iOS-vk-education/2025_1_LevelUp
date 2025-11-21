//
//  ContentView.swift
//  LevelUp
//
//  Created by Андрей Прибавкин on 9.11.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var habitViewModel = HabitViewModel()

    var body: some View {
        TabView {
            TodayTasksView()
                .tabItem {
                    Label("Задачи", systemImage: "target")
                }
            HabitsView()
                .tabItem {
                    Label("Привычки", systemImage: "leaf.circle.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
        }
        .environmentObject(habitViewModel)
    }
}


#Preview {
    ContentView()
        .environmentObject(HabitViewModel())
}
