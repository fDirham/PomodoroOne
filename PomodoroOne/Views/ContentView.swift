//
//  ContentView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher> = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
        else{
            modelData.timerLeftS -= 1
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
