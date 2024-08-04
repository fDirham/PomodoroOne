//
//  KeyboardShortcutsField.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/4/24.
//

import SwiftUI
import KeyboardShortcuts

struct KeyboardShortcutsField: View {
    let text: String
    var shortcutName: KeyboardShortcuts.Name
    
    var body: some View {
        HStack {
        Text(text)
        Spacer()
        KeyboardShortcuts.Recorder(text, name: shortcutName)
            .labelsHidden()
        }
    }
}

#Preview {
    KeyboardShortcutsField(text: "start pause session", shortcutName: .startPauseSession)
}
