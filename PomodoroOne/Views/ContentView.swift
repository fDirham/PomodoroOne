//
//  ContentView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var soundPlayer: AVAudioPlayer?

    @ObservedObject var modelData: ModelData
    
    var body: some View {
        VStack {
            Spacer()
            CircleTimerView(size: 130, lineWidth: 8, knobSize: 16, pctDone: modelData.timerPctDone)
                .overlay{
                    VStack(spacing:5) {
                        Text(modelData.timerStringVal)
                            .font(.system(size: 32))
                            .onReceive(timer) {_ in
                                updateTimer()
                            }
                        Button(action: {
                            modelData.isPaused ?
                            resumePomodoro()
                            :
                            pausePomodoro()
                        }){
                            Image(systemName: modelData.isPaused ?  "play.fill" :"pause.fill")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            Spacer()
            HStack{
                Spacer()
                Menu {
                    Button("Settings", action: {
                        print("TODO")
                    })
                    Button("Quit", action: {exit(0)})
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .menuIndicator(.hidden)
                .fixedSize()
            }
        }
        .padding()
        .frame(width: 176, height: 220)
    }
    
    private func updateTimer() {
        if modelData.isPaused {
            self.timer.upstream.connect().cancel()
        }
        else {
            modelData.timerLeftS -= 1
        }
        
        if modelData.timerLeftS <= 0{
            handleTimerDone()
        }
    }
    
    private func pausePomodoro(){
        modelData.isPaused = true
        self.timer.upstream.connect().cancel()
    }
    
    private func resumePomodoro(){
        modelData.isPaused = false
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    private func handleTimerDone(){
        self.pausePomodoro()
        modelData.timerLeftS = modelData.timerStartS
        playSound()
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


struct ContentView_Preview: PreviewProvider {
    struct Container: View {
        @StateObject var modelData = ModelData()
        var body: some View {
            ContentView(modelData: modelData)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
