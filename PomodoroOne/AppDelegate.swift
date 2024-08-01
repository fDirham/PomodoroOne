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
    let popover = NSPopover()
    private var statusBarItem: NSStatusItem! // Need to keep this otherwise menu item just disappears
    private var iconView: NSHostingView<MenuBarView>!
    private let smallMenuWidth = 35
    private let largeMenuWidth = 80
    
    private var settingsWindow: NSWindow?
    
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        // Add content view to pop over
        let contentView = ContentView()
        // Create a popover
        popover.contentSize = NSSize(width: 176, height: 220)
        // Embed our SwiftUI view into the popover
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // Create menu bar icon
        let iconSwiftUI = MenuBarView(resizeFrame: resizeFrame)
        iconView = NSHostingView(rootView: iconSwiftUI)
        iconView?.frame = NSRect(x: 0, y: 0, width: smallMenuWidth, height: 22)
        
        if let button = statusBarItem.button {
            // Menu buttons
            button.addSubview(iconView!)
            button.frame = iconView!.frame
            
            // Register click action
            // See Functions file
            button.action = #selector(AppDelegate.togglePopover(_:))
            // Dispatch click states
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let popover = self?.popover {
                if popover.isShown {
                    self?.closePopover(event)
                }
            }
        }
        eventMonitor?.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusBarItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func resizeFrame(enlarge: Bool){
        let newWidth = enlarge ? largeMenuWidth : smallMenuWidth
        let newFrame = NSRect(x: 0, y: 0, width: newWidth, height: 22)
        if let button = statusBarItem.button {
            // Menu buttons
            iconView!.frame = newFrame
            button.frame = newFrame
        }
    }
    
    func openSettings(){
        if self.settingsWindow == nil {
            let newWindow = NSWindow()
            let contentViewSwiftUI = SettingsView()
            let contentView = NSHostingView(rootView: contentViewSwiftUI)
            contentView.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
            
            newWindow.contentView = contentView
            newWindow.title = "New Window"
            newWindow.isOpaque = false
            newWindow.isMovableByWindowBackground = true
            var frame = newWindow.frame
            frame.size = NSMakeSize(300, 200 )
            newWindow.setFrame(frame, display: true)

            self.settingsWindow = newWindow
        }
        else {
            self.settingsWindow!.collectionBehavior.insert(.moveToActiveSpace)
        }
        self.settingsWindow!.center()
        self.settingsWindow!.orderFrontRegardless()
    }
}

