//
//  TopNavigationBar.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI

struct TopNavigationBar: View {
    var profileInitials: String = "BA"
    @Binding var showingMenu: Bool
    @Binding var showingSearch: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Left: Hamburger menu
            Button(action: {
                showingMenu = true
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            // Right: Search, more options, profile
            HStack(spacing: 16) {
                Button(action: {
                    showingSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }

                Button(action: {
                    // More options - future feature
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }

                // Profile initials circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 32, height: 32)

                    Text(profileInitials)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 44)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.traceBackground1, Color.traceBackground2],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        TopNavigationBar(showingMenu: .constant(false), showingSearch: .constant(false))
    }
}
