//
//  ModelData.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import Foundation
import SwiftUI

class ModelData: ObservableObject {
    @Published var timerStartS: Int = 3
    @Published var timerLeftS: Int = 3
    @Published var isPaused: Bool = true
    
    // Keeping track of sessions
    @Published var sessionIndex: Int = 0
    @Published var restCounter: Int = 0
    @Published var workCounter: Int = 0
    @Published var targetWorkSessions: Int = 10
    @Published var whenToLongRest: Int = 3
    
    // Durations
    // TODO: Give better defaults and hook into config
    @Published var workSessionDurationS = 3
    @Published var restSessionDurationS = 2
    @Published var longRestSessionDurationS = 4
    @Published var isAutoPlay: Bool = false
    @Published var isOvertime: Bool = false

    // Keeping track of current day
    @Published var lastOpenedAt: Date = Date.now
    @Published var isNewDayButTimerRunning: Bool = false
    
    // Actions for contentView
    @Published var contentViewAction: String? = nil
    @Published var menuViewAction: String? = nil

    
    // Computed values

    var timerStringVal: String {
        let minutes = abs(timerLeftS) / 60 % 60
        let seconds = abs(timerLeftS) % 60
        let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let toReturn = "\(minutesStr):\(secondsStr)"
        if isOvertime {
            return "-" + toReturn
        }
        return toReturn
    }
    
    var timerPctDone: Double {
        let timeElapsed = timerStartS - timerLeftS
        if timeElapsed == 0 {
            return 0
        }
        if timeElapsed > 0 {
            return Double(timeElapsed) * 100 / Double(timerStartS)
        }
        else {
           return 100
        }
    }
    
    var currentSessionType: SessionType {
        return self.getSessionType()
    }
    
    var activeColor: Color {
        if currentSessionType == SessionType.work{
            return .work
        }
        return .rest
    }
    
    func handleTimerTick(){
        if isPaused {
            self.pauseTimer()
        }
        else {
            timerLeftS -= 1
        }
        
        if timerLeftS <= 0{
            self.handleTimerOnZero()
        }
    }
    
    func handleActionButtonPress(){
        if self.isOvertime {
            completeSession()
        }
        else {
            if self.isPaused {
                self.playTimer()
            }
            else{
                self.pauseTimer()
            }
        }
    }
    
    func pauseTimer(){
        self.isPaused = true
        self.menuViewAction = "stopTimer"
    }
    
    func playTimer(){
        self.isPaused = false
        self.menuViewAction = "startTimer"
    }
    
    private func handleTimerOnZero(){
        if isAutoPlay {
            completeSession()
        }
        else{
            self.isOvertime = true
        }
    }
    
    private func completeSession(){
        self.isOvertime = false
        
        let completedSessionType: SessionType = self.getSessionType()
        if completedSessionType == SessionType.work {
            self.workCounter += 1
            self.sessionIndex += 1
        }
        else {
            if !self.isNewDayButTimerRunning {
                self.restCounter += 1
                self.sessionIndex += 1
            }
        }

        if !self.isAutoPlay {
            self.pauseTimer()
        }

        let newSessionType = self.getSessionType()
        if newSessionType == SessionType.work {
            self.timerLeftS = self.workSessionDurationS
            self.timerStartS = self.workSessionDurationS
        }
        if newSessionType == SessionType.rest {
            self.timerLeftS = self.restSessionDurationS
            self.timerStartS = self.restSessionDurationS
        }
        if newSessionType == SessionType.longRest {
            self.timerLeftS = self.longRestSessionDurationS
            self.timerStartS = self.longRestSessionDurationS
        }
    }
    
    enum SessionType {
        case work
        case rest
        case longRest
    }
    
    func getSessionType() -> SessionType{
        let testSessionIdx = self.sessionIndex
        if testSessionIdx % 2 == 0 {
            return SessionType.work
        }
        
        if self.restCounter > 0 && (self.restCounter % self.whenToLongRest == 0){
            return SessionType.longRest
        }
        
        return SessionType.rest
    }
}
