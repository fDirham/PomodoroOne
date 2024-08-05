//
//  SettingsPickerView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/4/24.
//

import SwiftUI

struct SettingsPickerView<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View{
    let text: String
    let selection: Binding<SelectionValue>
    let content: () -> Content
    
    init(_ text: String, selection: Binding<SelectionValue>, content: @escaping ()-> Content){
        self.text = text
        self.selection = selection
        self.content = content
    }
    
    var body: some View {
        HStack{
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
            Picker(text, selection: selection) {
                content()
            }
            .labelsHidden()
            .frame(maxWidth: 120)
        }
    }
}

// TODO
//#Preview {
//    SettingsPickerView()
//}
