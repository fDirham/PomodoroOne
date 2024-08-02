//
//  PomodoroOneApp.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let startPauseSession = Self("startPauseSession")
}


@main
struct PomodoroOneApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
    
    
    // Uncomment for menu bar extra
//    var body: some Scene {
//        MenuBarExtra{
//            ContentView()
//        } label: {
//            MenuBarView(resizeFrame: {_ in})
//        }
//        .menuBarExtraStyle(.window)
//        
//        Settings {
//            SettingsView()
//        }
//    }
}


