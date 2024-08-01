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
    
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        // Add content view to pop over
        let contentView = ContentView(modelData: ModelData.shared)
        // Create a popover
        popover.contentSize = NSSize(width: 176, height: 220)
        // Embed our SwiftUI view into the popover
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        // Create menu bar icon
        let iconSwiftUI = MenuBarView(modelData: ModelData.shared)
        let iconView = NSHostingView(rootView: iconSwiftUI)
        iconView.frame = NSRect(x: 0, y: 0, width: 80, height: 22)
        
        if let button = statusBarItem.button {
            // Menu buttons
            button.addSubview(iconView)
            button.frame = iconView.frame
            
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
}

