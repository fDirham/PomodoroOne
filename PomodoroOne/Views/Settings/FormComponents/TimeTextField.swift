//
//  TimeTextField.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/2/24.
//
import SwiftUI

struct TimeTextField: View {
    let title: String
    @Binding var timeS: Int
    @State private var timeM: Int = 0
    @Environment(ModelData.self) private var modelData: ModelData
    
    var body: some View {
        Form{
            SettingsTextFieldView(title, value: $timeM)
                .onChange(of: timeM) {
                    timeS = timeM * 60
                    modelData.onSettingsDurationUpdate()
                }
        }
        .onAppear {
            timeM = timeS / 60
        }
    }
}

struct TimeTextField_Preview: PreviewProvider {
    struct Container: View {
        @State private var timeVal = 60
        
        var body: some View {
            TimeTextField(title: "work duration (minutes)", timeS: $timeVal)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
