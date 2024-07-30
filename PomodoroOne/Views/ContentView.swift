//
//  ContentView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isPaused: Bool = false
    @State private var timerPctDone: Double = 30
    
    var body: some View {
        VStack {
            Spacer()
            CircleTimerView(size: 130, lineWidth: 8, knobSize: 16, pctDone: timerPctDone)
                .overlay{
                    VStack(spacing:5) {
                        Text("12:34")
                            .font(.system(size: 32))
                        Button(action: {isPaused.toggle()}){
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
}

#Preview {
    ContentView()
}
