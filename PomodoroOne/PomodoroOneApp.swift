//
//  PomodoroOneApp.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import Cocoa

@main
struct PomodoroOneApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            
            EmptyView()
        }
    }
    
}


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBar = StatusBarController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
