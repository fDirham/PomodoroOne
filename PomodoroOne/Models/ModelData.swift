//
//  ModelData.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import Foundation
import SwiftUI

@Observable
class ModelData {
    static var shared = ModelData()
    
    var timerStartS: Int = 3
    var timerLeftS: Int = 3
    var isPaused: Bool = true
    
    // Keeping track of sessions
    var sessionIndex: Int = 0
    var restCounter: Int = 0
    var workCounter: Int = 0
    var targetWorkSessions: Int = 10
    var whenToLongRest: Int = 3
    
    // Durations
    // TODO: Give better defaults and hook into config
    var workSessionDurationS = 3
    var restSessionDurationS = 2
    var longRestSessionDurationS = 4
    var isAutoPlay: Bool = false
    var isOvertime: Bool = false
    var isOvertimeAllowed: Bool = false
    
    // Keeping track of current day
    var lastOpenedAt: Date = Date.now
    var isNewDayButTimerRunning: Bool = false
    
    // Actions for contentView
    var contentViewAction: String? = nil
    var menuViewAction: String? = nil
    
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
    
    var isNotStarted: Bool {
        return isPaused && (timerLeftS == timerStartS)
    }
    
    // Timer updates
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
    
    private func handleTimerOnZero(){
        if currentSessionType == SessionType.work {
            invokeMenuViewAction(actionVal: "soundWorkEnd")
        }
        else {
            invokeMenuViewAction(actionVal: "soundRestEnd")
        }
        
        if isAutoPlay {
            completeSession()
        }
        else{
            if isOvertimeAllowed {
                self.isOvertime = true
            }
            else {
                completeSession()
            }
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
    
    // User controls
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
        invokeMenuViewAction(actionVal: "stopTimer")
    }
    
    func playTimer(){
        self.isPaused = false
        invokeMenuViewAction(actionVal: "startTimer")
    }
    
    func handleResetSession(){
        self.isPaused = true
        self.timerLeftS = self.timerStartS
    }
    
    func handleSkipSession(){
        self.completeSession()
    }
    
    // Session types
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
    
    // View action invokes
    private func invokeContentViewAction(actionVal: String) {
        self.contentViewAction = actionVal
    }
    
    private func invokeMenuViewAction(actionVal: String) {
        self.menuViewAction = actionVal
    }
    
}
