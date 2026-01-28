//
//  ContentView.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/26/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = JournalDataManager()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            EntriesView(dataManager: dataManager)
                .tabItem {
                    Label("Entries", systemImage: "list.bullet")
                }
                .tag(0)

            CalendarView(dataManager: dataManager)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)

            MediaView(dataManager: dataManager)
                .tabItem {
                    Label("Media", systemImage: "photo")
                }
                .tag(2)
        }
        .tint(Color(red: 0.2, green: 0.4, blue: 0.8))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.95, green: 0.98, blue: 1.0, alpha: 0.95)

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
