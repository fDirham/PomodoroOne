//
//  SoundSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/2/24.
//

import SwiftUI

struct SoundSettingsView: View {
    @Environment(ModelData.self) private var modelData: ModelData
    
    var body: some View {
        @Bindable var modelData = modelData
        
        Form {
            VStack(alignment: .leading){
                SettingsSectionHeaderView("Session completed sounds", isFirst: true)
                SettingsPickerView("Work completed", selection: $modelData.soundWorkEnd) {
                    ForEach(appSoundsDict.sorted(by: >), id: \.key) { key, value in
                        Text(key)
                            .tag(value)
                    }
                }
                .onChange(of: modelData.soundWorkEnd) {
                    modelData.soundAction = "playWorkEnd"
                }
                SettingsPickerView("Rest completed", selection: $modelData.soundRestEnd) {
                    ForEach(appSoundsDict.sorted(by: >), id: \.key) { key, value in
                        Text(key)
                            .tag(value)
                    }
                }
                .onChange(of: modelData.soundRestEnd) {
                    modelData.soundAction = "playRestEnd"
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct SoundSettingsView_Preview: PreviewProvider {
    struct Container: View {
        @State private var modelData = ModelData()

        var body: some View {
            TabView{
                SoundSettingsView()
                    .environment(modelData)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        Container()
    }
}
