//
//  ToggleSettingsStyle.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/4/24.
//

import SwiftUI

struct ToggleSettingsStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Toggle(configuration)
                .labelsHidden()
        }
    }
}
