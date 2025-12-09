//
//  ContentView.swift
//  LevelUp
//
//  Created by Андрей Прибавкин on 9.11.25.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject private var habitViewModel: HabitViewModel

    var body: some View {
        TabView {
            TodayTasksView()
                .tabItem {
                    Label("Задачи", systemImage: "checklist")
                }
            HabitsView()
                .tabItem {
                    Label("Привычки", systemImage: "list.clipboard.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(HabitViewModel())
}
