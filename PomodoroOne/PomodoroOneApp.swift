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
//    @StateObject private var modelData = ModelData()
//    var body: some Scene {
//        MenuBarExtra{
//            ContentView(modelData: modelData)
//        } label: {
//            MenuBarView(modelData: modelData)
//        }
//        .menuBarExtraStyle(.window)
//    }
}


