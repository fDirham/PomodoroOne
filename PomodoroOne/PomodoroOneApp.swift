//
//  PomodoroOneApp.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI


@main
struct PomodoroOneApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
    
    
    // Uncomment for menu bar extra
//    var body: some Scene {
//        MenuBarExtra{
//            ContentView(modelData: ModelData.shared)
//        } label: {
//            MenuBarView(modelData: ModelData.shared)
//        }
//        .menuBarExtraStyle(.window)
//    }
}


