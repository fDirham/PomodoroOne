//
//  GeneralSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/1/24.
//

import SwiftUI
import KeyboardShortcuts

struct GeneralSettingsView: View {
    @Binding var modelData: ModelData
    
    var body: some View {
        Form {
            VStack{
                Section {
                    Toggle("Over time", isOn: $modelData.isOvertimeAllowed)
                    Toggle("Auto start next session", isOn: $modelData.isAutoPlay)
                }
                Section(header: Text("Keyboard shortcuts")) {
                    KeyboardShortcuts.Recorder("Start / Pause session", name: .startPauseSession)
                }
            }
        }
        .padding()
        .defaultAppStorage(.standard)
    }
}

struct GeneralSettingsView_Preview: PreviewProvider {
    struct Container: View {
        @State private var modelData = ModelData()

        var body: some View {
            TabView{
                GeneralSettingsView(modelData: $modelData)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        Container()
    }
}
