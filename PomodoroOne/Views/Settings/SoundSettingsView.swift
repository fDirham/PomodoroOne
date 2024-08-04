//
//  SoundSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/2/24.
//

import SwiftUI

struct SoundSettingsView: View {
    @Binding var modelData: ModelData
    
    var body: some View {
        Form {
            VStack{
                    SettingsPickerView("Work completed sound", selection: $modelData.soundWorkEnd) {
                        ForEach(appSoundsDict.sorted(by: >), id: \.key) { key, value in
                            Text(key)
                                .tag(value)
                        }
                    }
                    .onChange(of: modelData.soundWorkEnd) {
                        modelData.soundAction = "playWorkEnd"
                    }
                    SettingsPickerView("Rest completed sound", selection: $modelData.soundRestEnd) {
                        ForEach(appSoundsDict.sorted(by: >), id: \.key) { key, value in
                            Text(key)
                                .tag(value)
                        }
                    }
                    .onChange(of: modelData.soundRestEnd) {
                        modelData.soundAction = "playRestEnd"
                    }
            }
        }
        .padding()
        .defaultAppStorage(.standard)
    }
}

struct SoundSettingsView_Preview: PreviewProvider {
    struct Container: View {
        @State private var modelData = ModelData()

        var body: some View {
            TabView{
                SoundSettingsView(modelData: $modelData)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        Container()
    }
}
