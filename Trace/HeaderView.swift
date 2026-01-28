//
//  HeaderView.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI

struct HeaderView: View {
    var title: String = "Trace"
    var subtitle: String

    init(title: String = "Trace", subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle ?? String(Calendar.current.component(.year, from: Date()))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(subtitle)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 24)
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
            HeaderView()
            Spacer()
        }
    }
}
