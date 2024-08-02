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
            GeneralSettingsView(modelData: $modelData)
                .tabItem { Label("General", systemImage: "gear") }
            IntervalsSettingsView(modelData: $modelData)
                .tabItem { Label("Intervals", systemImage: "clock.fill") }
            SoundSettingsView(modelData: $modelData)
                .tabItem { Label("Sound", systemImage: "speaker.fill") }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
        .fixedSize()
        .focused($isViewFocused)
    }
}

#Preview {
    SettingsView()
}
