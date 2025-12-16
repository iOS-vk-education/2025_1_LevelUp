//
//  ContentView.swift
//  LevelUp
//
//  Created by Андрей Прибавкин on 9.11.25.
//

import SwiftUI
struct ContentView: View {
    @EnvironmentObject private var habitViewModel: HabitViewModel
    @StateObject private var todayTasksViewModel = TodayTasksViewModel()

    var body: some View {
        TabView {
            TodayTasksView()
                .environmentObject(todayTasksViewModel)
                .tabItem {
                    Label("Задачи", systemImage: "checklist")
                }
            HabitsView()
                .environmentObject(todayTasksViewModel)
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
