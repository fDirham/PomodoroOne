//
//  SettingsTextFieldView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/4/24.
//

import SwiftUI

struct SettingsTextFieldView<V>: View {
    private let labelText: String
    private let value: Binding<V>
   
    init(_ labelText: String, value: Binding<V>) {
        self.labelText = labelText
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(labelText)
            Spacer()
                .frame(maxWidth: .infinity)
            TextField(labelText, value: value, formatter: NumberFormatter())
                .textFieldStyle(.roundedBorder)
                .labelsHidden()
                .frame(maxWidth: 120)
        }
    }
}

//TODO
//#Preview {
//    SettingsTextFieldView()
//}
