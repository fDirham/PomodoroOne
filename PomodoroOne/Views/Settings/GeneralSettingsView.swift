//
//  GeneralSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/1/24.
//

import SwiftUI

struct GeneralSettingsView: View {
    @Environment(ModelData.self) private var modelData: ModelData
    
    var body: some View {
        @Bindable var modelData = modelData
        Form {
            VStack{
                SettingsSectionHeaderView("General", isFirst:true)
                Toggle("Over time", isOn: $modelData.isOvertimeAllowed)
                    .toggleStyle(ToggleSettingsStyle())
                Toggle("Auto start next session", isOn: $modelData.isAutoPlay)
                    .toggleStyle(ToggleSettingsStyle())
                SettingsSectionHeaderView("Keyboard shortcuts")
                KeyboardShortcutsField(text: "Start / Pause session", shortcutName: .startPauseSession)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .defaultAppStorage(.standard)
        .onDisappear{
            print("bye")
        }
    }
}

struct GeneralSettingsView_Preview: PreviewProvider {
    struct Container: View {
        @State private var modelData = ModelData()

        var body: some View {
            TabView{
                GeneralSettingsView()
                    .environment(modelData)
            }
            .padding()
            .frame(width: 300, height: 500)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
