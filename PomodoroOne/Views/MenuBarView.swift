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
    @ObservedObject var modelData: ModelData
    
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
            Text(modelData.timerStringVal)
                .font(.system(size: 15))
                .foregroundStyle(modelData.isOvertime ? modelData.activeColor : .foreground)
            Image(menuBarFileName)
                .resizable()
                .frame(width: 17, height: 17)
        }
        .onReceive(timer) {_ in
            modelData.handleTimerTick()
        }
        .onChange(of: modelData.menuViewAction, initial: false, handleModelDataAction)
        .task {
            do {
                try await modelData.loadUserConfig()
            } catch {
                do{
                    try await modelData.saveUserConfig()
                }
                catch {
                    // TODO
                }
            }
        }
    }

    private func handleModelDataAction(){
        if let actionVal = modelData.menuViewAction {
            switch actionVal {
            case "stopTimer":
                stopTimer()
            case "startTimer":
                startTimer()
            case "soundRestEnd":
                playSound()
            case "soundWorkEnd":
                playSound()
            default:
                print("ERROR: Unsupported action for menu")
            }
            modelData.menuViewAction = nil
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
        @StateObject var modelData = ModelData()
        var body: some View {
            MenuBarView(modelData: modelData)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
