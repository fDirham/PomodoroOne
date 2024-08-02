//
//  IntervalsSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/1/24.
//

import SwiftUI

struct IntervalsSettingsView: View {
    @Binding var modelData: ModelData
    
    var body: some View {
        Form {
            VStack{
                Spacer()
                Section(header: Text("Durations")){
                    TimeTextField(title: "Work duration", timeS: $modelData.workSessionDurationS)
                    TimeTextField(title: "Rest duration", timeS: $modelData.restSessionDurationS)
                    TimeTextField(title: "Long rest duration", timeS: $modelData.longRestSessionDurationS)
                }
                Spacer()
                Section(header: Text("Frequencies")){
                    TextField("Target work sessions per day", value: $modelData.targetWorkSessions, format: .number)
                    TextField("Long rest every _ rest sessions", value: $modelData.whenToLongRest, format: .number)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
            }
        }
        .padding()
        .defaultAppStorage(.standard)
    }
}

struct IntervalsSettingsView_Preview: PreviewProvider {
    struct Container: View {
        @State private var modelData = ModelData()
        
        var body: some View {
            TabView{
                IntervalsSettingsView(modelData: $modelData)
            }.padding()
        }
    }
    
    static var previews: some View {
        Container()
    }
}
