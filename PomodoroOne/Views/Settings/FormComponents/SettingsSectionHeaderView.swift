//
//  SettingSectionHeaderView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 8/4/24.
//

import SwiftUI

struct SettingsSectionHeaderView: View {
    let title: String
    let isFirst: Bool
    
    init(_ title: String, isFirst: Bool = false){
        self.title = title
        self.isFirst = isFirst
    }
    
    var body: some View {
        HStack{
            Text(title)
                .font(.headline)
            Spacer()
        }
        .if(!isFirst) { view in
            view.padding(.top, 30)
        }
    }
}

#Preview {
    SettingsSectionHeaderView("test header")
}
