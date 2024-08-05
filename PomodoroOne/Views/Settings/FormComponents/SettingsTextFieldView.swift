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
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField(labelText, value: value, formatter: NumberFormatter())
                .textFieldStyle(.roundedBorder)
                .labelsHidden()
                .frame(maxWidth: 120)
        }
    }
}

struct SettingsTextFieldView_Preview: PreviewProvider {
    struct Container: View {
        @State var someVal = ""
        
        var body: some View {
            SettingsTextFieldView("some label", value: $someVal)
        }
    }
    
    static var previews: some View {
        Container()
    }
}

