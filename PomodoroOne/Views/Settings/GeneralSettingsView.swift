//
//  GeneralSettingsView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/1/24.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("testVal") private var testVal = "hello there"
    
    var body: some View {
        Form {
            TextField("wow", text: $testVal)
        }
    }
}

#Preview {
    GeneralSettingsView()
}
