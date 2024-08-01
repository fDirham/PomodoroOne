//
//  SettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/1/24.
//

import SwiftUI

struct SettingsView: View {
    @FocusState private var isViewFocused: Bool
    @State private var modelData = ModelData.shared

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem { Label("General", systemImage: "gear") }
            IntervalsSettingsView()
                .tabItem { Label("Intervals", systemImage: "clock.fill") }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
        .focused($isViewFocused)
    }
}

#Preview {
    SettingsView()
}
