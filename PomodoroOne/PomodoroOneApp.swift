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

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
