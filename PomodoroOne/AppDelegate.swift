//
//  AppDelegate.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/31/24.
//

import Foundation
import Cocoa
import SwiftUI

class AlwaysKeyWindow : NSWindow {
    override var canBecomeMain: Bool { return true }
    override var canBecomeKey: Bool { return true }
}

extension NSPopover {
    
    private struct Keys {
        static var backgroundViewKey = "backgroundKey"
    }
    
    private var backgroundView: NSView {
        let bgView = objc_getAssociatedObject(self, &Keys.backgroundViewKey) as? NSView
        if let view = bgView {
            return view
        }
        
        let view = NSView()
        objc_setAssociatedObject(self, &Keys.backgroundViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        NotificationCenter.default.addObserver(self, selector: #selector(popoverWillOpen(_:)), name: NSPopover.willShowNotification, object: nil)
        return view
    }
    
    @objc private func popoverWillOpen(_ notification: Notification) {
        if backgroundView.superview == nil {
            if let contentView = contentViewController?.view, let frameView = contentView.superview {
                frameView.wantsLayer = true
                backgroundView.frame = NSInsetRect(frameView.frame, 1, 1)
                backgroundView.autoresizingMask = [.width, .height]
                frameView.addSubview(backgroundView, positioned: .below, relativeTo: contentView)
            }
        }
    }
    
    var backgroundColor: NSColor? {
        get {
            if let bgColor = backgroundView.layer?.backgroundColor {
                return NSColor(cgColor: bgColor)
            }
            return nil
        }
        set {
            backgroundView.wantsLayer = true
            backgroundView.layer?.backgroundColor = newValue?.cgColor
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let popover = NSPopover()
    private var statusBarItem: NSStatusItem! // Need to keep this otherwise menu item just disappears
    private var iconView: NSHostingView<MenuBarView>!
    private var invisPopupWindow: NSWindow!
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
        popover.backgroundColor = .background
        
        // Create menu bar icon
        let iconSwiftUI = MenuBarView(resizeFrame: resizeFrame)
        iconView = NSHostingView(rootView: iconSwiftUI)
        iconView?.frame = NSRect(x: 0, y: 0, width: smallMenuWidth, height: 22)
        
        
        // Create invisible window
        invisPopupWindow = AlwaysKeyWindow(contentRect: NSMakeRect(0, 0, 20, 1), styleMask: .borderless, backing: .buffered, defer: false)
        invisPopupWindow.backgroundColor = .red
        invisPopupWindow.alphaValue = 0
        invisPopupWindow.hidesOnDeactivate = true
        
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
            self.invisPopupWindow.collectionBehavior.insert(.moveToActiveSpace)
            
            // find the coordinates of the statusBarItem in screen space
            let buttonRect:NSRect = button.convert(button.bounds, to: nil)
            let screenRect:NSRect = button.window!.convertToScreen(buttonRect)
            
            // calculate the bottom center position (10 is the half of the window width)
            let posX = screenRect.origin.x + (screenRect.width / 2) - 10
            let posY = screenRect.origin.y
            
            // position and show the window
            self.invisPopupWindow.setFrameOrigin(NSPoint(x: posX, y: posY))
            self.invisPopupWindow.makeKeyAndOrderFront(self)
            NSApp.activate(ignoringOtherApps: true)

            // Show popover
            self.popover.show(relativeTo: self.invisPopupWindow.contentView!.frame, of: self.invisPopupWindow.contentView!, preferredEdge: NSRectEdge.minY)
            
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
            let contentViewSwiftUI = SettingsView()
            let contentView = NSHostingView(rootView: contentViewSwiftUI)
            let newWindow = NSWindow(contentViewController: NSHostingController(rootView: contentViewSwiftUI))

            newWindow.contentView = contentView
            newWindow.title = "Settings"
            newWindow.isOpaque = false
            newWindow.isMovableByWindowBackground = true
            newWindow.hidesOnDeactivate = true
            self.settingsWindow = newWindow
        }
        else {
            self.settingsWindow!.collectionBehavior.insert(.moveToActiveSpace)
        }
        self.settingsWindow!.center()
        self.settingsWindow!.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

