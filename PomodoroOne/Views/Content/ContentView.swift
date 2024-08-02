//
//  ContentView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/29/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var confirmSkip: Bool = false
    @State private var confirmReset: Bool = false
    @State private var modelData = ModelData.shared
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate


    var topTextVal: String {
        if modelData.currentSessionType == ModelData.SessionType.work {
            return "work"
        }
        return "rest"
    }
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Spacer()
                Text(topTextVal)
                    .fontWeight(.semibold)
                Spacer()
                Menu {
                    Button("Skip", action: {
                        confirmSkip = true
                    })
                    Button("Redo", role: .destructive, action: {
                        confirmReset = true
                    })
                } label: {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .menuIndicator(.hidden)
                .fixedSize()
            }
            Spacer()
            CircleTimerView(size: 130, lineWidth: 8, knobSize: 16, pctDone: modelData.timerPctDone, activeColor: modelData.activeColor)
                .overlay{
                    VStack(spacing:5) {
                        Text(modelData.timerStringVal)
                            .font(.system(size: 32))
                        Button(action: {
                            modelData.handleActionButtonPress()
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
                Spacer()
                Text("Today \(modelData.workCounter)/\(modelData.targetWorkSessions)")
                Spacer()
                Menu {
                    Button("Settings") {
                        appDelegate.openSettings()
                    }
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
        .fixedSize()
        .confirmationDialog("Skip session", isPresented: $confirmSkip) {
            Button("Skip", role: .destructive) {
                modelData.handleSkipSession()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to skip the current session?")
        }
        .confirmationDialog("Redo session", isPresented: $confirmReset) {
            Button("Redo", role: .destructive) {
                modelData.handleResetSession()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to redo the current session?")
        }
    }
}


struct ContentView_Preview: PreviewProvider {
    struct Container: View {
        var body: some View {
            ContentView()
        }
    }
    
    static var previews: some View {
        Container()
    }
}
