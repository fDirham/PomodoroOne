//
//  ContentView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var modelData: ModelData
    
    var body: some View {
        VStack {
            Spacer()
            CircleTimerView(size: 130, lineWidth: 8, knobSize: 16, pctDone: modelData.timerPctDone)
                .overlay{
                    VStack(spacing:5) {
                        Text(modelData.timerStringVal)
                            .font(.system(size: 32))
                        Button(action: {
                            modelData.isPaused ?
                            modelData.playTimer()
                            :
                            modelData.pauseTimer()
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
