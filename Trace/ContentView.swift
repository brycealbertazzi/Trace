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
    @State private var showingMenu = false
    @State private var showingSearch = false

    var body: some View {
        ZStack {
            // Blue gradient background (full screen)
            LinearGradient(
                colors: [Color.traceBackground1, Color.traceBackground2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Navigation Bar
                TopNavigationBar(
                    showingMenu: $showingMenu,
                    showingSearch: $showingSearch
                )
                .padding(.top, 8)

                // Header with title and year
                HeaderView(title: "Trace")

                // Tab Switcher
                CustomTabSwitcher(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                // White content area with rounded top corners
                ZStack {
                    Color.traceContentBg
                        .cornerRadius(24, corners: [.topLeft, .topRight])

                    // Tab content based on selectedTab
                    Group {
                        switch selectedTab {
                        case 0:
                            EntriesContentView(dataManager: dataManager)
                        case 1:
                            CalendarContentView(dataManager: dataManager)
                        case 2:
                            MediaContentView(dataManager: dataManager)
                        default:
                            EntriesContentView(dataManager: dataManager)
                        }
                    }
                    .transition(.opacity)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
