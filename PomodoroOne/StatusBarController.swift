//
//  StatusBarController.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import AppKit
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem
    private var mainView: NSView

    init(_ view: NSView) {
        let contentView = ContentView()
        let mainView = NSHostingView(rootView: contentView)
        mainView.frame =  NSRect(x: 0, y: 0, width: 200, height: 200)
        
        self.mainView = mainView
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let statusBarButton = statusItem.button {
            let iconSwiftUI = MenuBarView()
            let iconView = NSHostingView(rootView: iconSwiftUI)
            iconView.frame = NSRect(x: 0, y: 0, width: 120, height: 22)
            
            let menuItem = NSMenuItem()
            menuItem.view = mainView
            
            let menu = NSMenu()
            menu.addItem(menuItem)

            statusBarButton.addSubview(iconView)
            statusBarButton.frame = iconView.frame
            
            statusItem.menu = menu
        }
    }
}
