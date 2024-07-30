//
//  ContentView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var isPaused: Bool = true
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var timerStartS: Int = 100
    @State private var timerCountS: Int = 100
    
    private var timerValString: String{
        let minutes = timerCountS / 60 % 60
        let seconds = timerCountS % 60
        return "\(minutes):\(seconds)"
    }
    
    private var timerPctDone: Double {
        let timeElapsed = timerStartS - timerCountS
        return  Double(timeElapsed) * 100 / Double(timerStartS)
    }

    init(){
        let newTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.timer = newTimer
    }
    
    var body: some View {
        VStack {
            Spacer()
            CircleTimerView(size: 130, lineWidth: 8, knobSize: 16, pctDone: timerPctDone)
                .overlay{
                    VStack(spacing:5) {
                        Text(timerValString)
                            .font(.system(size: 32))
                            .onReceive(timer) {_ in
                                updateTimer()
                            }
                        Button(action: {
                            isPaused ?
                            resumePomodoro()
                            :
                            pausePomodoro()
                        }){
                            Image(systemName: isPaused ?  "play.fill" :"pause.fill")
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
        .frame(width: 176, height: 180)
    }
    
    private func updateTimer() {
        if isPaused {
            stopTimer()
        }
        else{
            timerCountS -= 1
        }
    }
    
    private func pausePomodoro(){
        isPaused = true
        stopTimer()
    }
    
    private func resumePomodoro(){
        isPaused = false
        startTimer()
    }
    
    private func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    private func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}

#Preview {
    ContentView()
}
