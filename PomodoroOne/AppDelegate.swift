//
//  AppDelegate.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/31/24.
//

import Foundation
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var modelData = ModelData()
    private var popover: NSPopover!
    private var statusBarItem: NSStatusItem! // Need to keep this otherwise menu item just disappears
    let invisibleWindow = NSWindow(contentRect: NSMakeRect(0, 0, 20, 5), styleMask: .borderless, backing: .buffered, defer: false)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        invisibleWindow.backgroundColor = .red
        invisibleWindow.alphaValue = 0
        
        // Get SwiftUI View
        let contentView = ContentView(modelData: modelData)
        // Create a popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 176, height: 220)
        popover.behavior = .transient
        // Embed our SwiftUI view into the popover
        popover.contentViewController = NSHostingController(rootView: contentView)
        // Register it
        self.popover = popover
        self.popover.contentViewController?.view.window?.becomeKey()
        
        
        let iconSwiftUI = MenuBarView(modelData: modelData)
        let iconView = NSHostingView(rootView: iconSwiftUI)
        iconView.frame = NSRect(x: 0, y: 0, width: 80, height: 22)
        
        if let button = statusBarItem.button {
            
            // Menu buttons
            button.addSubview(iconView)
            button.frame = iconView.frame
            
            // Register click action
            // See Functions file
            button.action = #selector(togglePopover(_:))
            // Dispatch click states
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate {
    
    @objc func openAbout() {
        print("Open about")
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    func closePopover() {
        popover.close()
    }
    
    @objc func doStuff() {
        print("Do stuff")
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.leftMouseUp {
            if let sbutton = statusBarItem.button {
                if popover.isShown {
                    popover.performClose(sender)
                } else {
                    // find the coordinates of the statusBarItem in screen space
                    let buttonRect: NSRect = sbutton.convert(sbutton.bounds, to: nil)
                    let screenRect: NSRect = sbutton.window!.convertToScreen(buttonRect)
                    
                    // calculate the bottom center position (10 is the half of the window width)
                    let posX = screenRect.origin.x + (screenRect.width / 2) - 10
                    let posY = screenRect.origin.y
                    
                    // position and show the window
                    invisibleWindow.setFrameOrigin(NSPoint(x: posX, y: posY))
                    invisibleWindow.makeKeyAndOrderFront(self)
                    NSApplication.shared.presentationOptions = []
                    // position and show the NSPopover
                    popover.show(relativeTo: invisibleWindow.contentView!.frame, of: invisibleWindow.contentView!, preferredEdge: NSRectEdge.minY)
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
        } else if event.type == NSEvent.EventType.rightMouseUp {
            let menu = NSMenu()
            menu.addItem(withTitle: "About PomodoroOne", action: #selector(openAbout), keyEquivalent: "c")
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "PomodoroOne v1.0", action: nil, keyEquivalent: ""))
            menu.addItem(withTitle: "Quit App", action: #selector(quit), keyEquivalent: "q")
            
            statusBarItem.menu = menu
            statusBarItem.button?.performClick(nil)
            statusBarItem.menu = nil
        }
    }
}
