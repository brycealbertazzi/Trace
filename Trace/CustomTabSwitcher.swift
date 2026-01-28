//
//  CustomTabSwitcher.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI

struct CustomTabSwitcher: View {
    @Binding var selectedTab: Int
    let tabs: [String]

    init(selectedTab: Binding<Int>, tabs: [String] = ["Entries", "Calendar", "Media"]) {
        self._selectedTab = selectedTab
        self.tabs = tabs
    }

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                VStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    }) {
                        Text(tab)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedTab == index ? .traceBlue : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }

                    // Active indicator
                    if selectedTab == index {
                        Capsule()
                            .fill(Color.traceBlue)
                            .frame(height: 2)
                            .matchedGeometryEffect(id: "tab_indicator", in: animation)
                    } else {
                        Capsule()
                            .fill(Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
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

        VStack {
            Spacer()
            CustomTabSwitcher(selectedTab: .constant(0))
                .padding(.horizontal, 20)
            Spacer()
        }
    }
}
