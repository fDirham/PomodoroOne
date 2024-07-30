//
//  StatusBarController.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import AppKit
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem // Need to keep this otherwise menu item just disappears
    private var modelData = ModelData()
    
    init() {
        let contentView = ContentView(modelData: modelData)
        let mainView = NSHostingView(rootView: contentView)
        mainView.frame =  NSRect(x: 0, y: 0, width: 176, height: 220)
        
        let iconSwiftUI = MenuBarView(modelData: modelData)
        let iconView = NSHostingView(rootView: iconSwiftUI)
        iconView.frame = NSRect(x: 0, y: 0, width: 80, height: 22)

        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let statusBarButton = statusItem.button {
            let menuItem = NSMenuItem()
            menuItem.view = mainView
            
            let menu = NSMenu()
            menu.addItem(menuItem)

            // Menu buttons
            statusBarButton.addSubview(iconView)
            statusBarButton.frame = iconView.frame
            
            // What gets shown when clicked
            statusItem.menu = menu
        }
    }
}
