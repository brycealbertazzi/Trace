//
//  ColorExtensions.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI

extension Color {
    // Primary blue for buttons, active tab, and tints
    static let traceBlue = Color(red: 0.2, green: 0.4, blue: 0.8)

    // Lighter blue for gradients and secondary elements
    static let traceLightBlue = Color(red: 0.3, green: 0.5, blue: 0.9)

    // Background gradient colors - darker blue for better white text contrast
    static let traceBackground1 = Color(red: 0.1, green: 0.3, blue: 0.65)
    static let traceBackground2 = Color(red: 0.15, green: 0.4, blue: 0.8)

    // Content background (slightly warm white)
    static let traceContentBg = Color.white

    // Text colors
    static let traceHeading = Color(red: 0.2, green: 0.4, blue: 0.7)

    // Tab bar background
    static let traceTabBarBg = Color(red: 0.95, green: 0.98, blue: 1.0)
}
