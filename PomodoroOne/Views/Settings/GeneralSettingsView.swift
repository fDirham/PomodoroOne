//
//  GeneralSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/1/24.
//

import SwiftUI

struct GeneralSettingsView: View {
    @Binding var modelData: ModelData
    
    var body: some View {
        Form {
            VStack{
                Toggle("allow over time", isOn: $modelData.isOvertimeAllowed)
                Toggle("auto start next session", isOn: $modelData.isAutoPlay)
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
            GeneralSettingsView(modelData: $modelData)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
