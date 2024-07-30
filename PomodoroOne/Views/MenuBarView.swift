//
//  MenuBarView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var modelData: ModelData
    
    var body: some View {
        HStack{
            Text(modelData.timerStringVal)
                .font(.system(size: 14))
            Image("menu-bar-icon__on")
                .resizable()
                .frame(width: 17, height: 17)
        }
    }
}

struct MenuBarView_Preview: PreviewProvider {
    struct Container: View {
        @StateObject var modelData = ModelData()
        var body: some View {
            MenuBarView(modelData: modelData)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
