//
//  MenuBarView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import AVFoundation

struct MenuBarView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var soundPlayer: AVAudioPlayer?
    @State private var modelData = ModelData.shared
    let resizeFrame: (Bool)-> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var menuBarFileName: String {
        if modelData.isPaused{
            if colorScheme == .dark {
                return "menu-bar-icon__white"
            }
            return "menu-bar-icon__black"
        }
        if modelData.currentSessionType == ModelData.SessionType.work {
            return "menu-bar-icon__on"
        }
        else {
            return "menu-bar-icon__rest"
        }
    }
    
    var body: some View {
        HStack{
            if !modelData.isNotStarted {
                Text(modelData.timerStringVal)
                    .font(.system(size: 15))
                    .foregroundStyle(modelData.isOvertime ? modelData.activeColor : .foreground)
            }
            Image(menuBarFileName)
                .resizable()
                .frame(width: 17, height: 17)
        }
        .task {
            modelData.loadInitValues()
        }
        .onReceive(timer) {_ in
            modelData.handleTimerTick()
        }
        .onChange(of: modelData.soundAction, handleSoundAction)
        .onChange(of: modelData.timerAction, handleTimerAction)
        .onChange(of: modelData.isNotStarted) {
            resizeFrame(!modelData.isNotStarted)
        }
    }

    private func handleSoundAction(){
        if let actionVal = modelData.soundAction {
            switch actionVal {
            case "playRestEnd":
                playSound()
            case "playWorkEnd":
                playSound()
            default:
                print("ERROR: Unsupported action for sound")
            }
            modelData.soundAction = nil
        }
    }
    
    private func handleTimerAction(){
        if let actionVal = modelData.timerAction {
            switch actionVal {
            case "stop":
                stopTimer()
            case "start":
                startTimer()
            default:
                print("ERROR: Unsupported action for timer")
            }
            modelData.timerAction = nil
        }
    }

    private func stopTimer(){
        self.timer.upstream.connect().cancel()
    }
    
    private func startTimer(){
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    private func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "ding", withExtension: "wav") else {
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print("Failed to load the sound: \(error)")
        }
        soundPlayer?.play()
    }
}

struct MenuBarView_Preview: PreviewProvider {
    struct Container: View {
        @State var modelData = ModelData()
        
        var body: some View {
            MenuBarView(resizeFrame: {_ in})
                .environment(modelData)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
