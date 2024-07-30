//
//  MenuBarView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI

struct MenuBarView: View {
    var body: some View {
        HStack{
            Text("20:24")
                .font(.system(size: 14))
            Image("menu-bar-icon__on")
                .resizable()
                .frame(width: 17, height: 17)
        }
    }
}

#Preview {
    MenuBarView()
}
