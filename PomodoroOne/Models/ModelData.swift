//
//  ModelData.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import Foundation
import SwiftUI
import ObservableUserDefault
import KeyboardShortcuts

@Observable class ModelData {
    static var shared = ModelData()
    
    var timerStartS: Int = 0
    var timerLeftS: Int = 0
    var isPaused: Bool = true
    
    // Keeping track of sessions
    var sessionIndex: Int = 0
    var restCounter: Int = 0
    var workCounter: Int = 0
    var isOvertime: Bool = false

    // Target configs
    @ObservableUserDefault(.init(key: "TARGET_WORK_SESSIONS", defaultValue: 10, store: .standard))
    @ObservationIgnored
    var targetWorkSessions: Int
    
    @ObservableUserDefault(.init(key: "WHEN_TO_LONG_REST", defaultValue: 4, store: .standard))
    @ObservationIgnored
    var whenToLongRest: Int
    
    // Duration configs
    // TODO: Set better defaults
    @ObservableUserDefault(.init(key: "DURATION_WORK_SESH", defaultValue: 1500, store: .standard))
    @ObservationIgnored
    var workSessionDurationS: Int
    
    @ObservableUserDefault(.init(key: "DURATION_REST_SESH", defaultValue: 300, store: .standard))
    @ObservationIgnored
    var restSessionDurationS: Int
    
    @ObservableUserDefault(.init(key: "DURATION_LONG_REST_SESH", defaultValue: 900, store: .standard))
    @ObservationIgnored
    var longRestSessionDurationS: Int
    
    @ObservableUserDefault(.init(key: "AUTO_PLAY_ENABLED", defaultValue: false, store: .standard))
    @ObservationIgnored
    var isAutoPlay: Bool
    
    @ObservableUserDefault(.init(key: "OVER_TIME_ENABLED", defaultValue: true, store: .standard))
    @ObservationIgnored
    var isOvertimeAllowed: Bool
    
    // Sound settings
    @ObservableUserDefault(.init(key: "SOUND_REST_END", defaultValue: "sound-alarm-clock", store: .standard))
    @ObservationIgnored
    var soundRestEnd: String
    
    @ObservableUserDefault(.init(key: "SOUND_WORK_END", defaultValue: "sound-alarm-clock", store: .standard))
    @ObservationIgnored
    var soundWorkEnd: String

    // Constructor
    init() {
        KeyboardShortcuts.onKeyUp(for: .startPauseSession) { [self] in
            self.handleActionButtonPress()
        }
    }
    
    // Keeping track of current day
    var lastOpenedAt: Date = Date.now
    var isNewDayButTimerRunning: Bool = false
    
    // Actions for contentView
    var timerAction: String? = nil
    var soundAction: String? = nil
    
    
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
        
        if timerLeftS == 0{
            self.handleTimerOnZero()
        }
    }
    
    private func handleTimerOnZero(){
            if self.currentSessionType == SessionType.work {
                self.soundAction = "playWorkEnd"
            }
            else {
                self.soundAction = "playRestEnd"
            }
        
            if self.isAutoPlay {
                self.completeSession()
            }
            else{
                if self.isOvertimeAllowed {
                    self.isOvertime = true
                }
                else {
                    self.completeSession()
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
        self.timerAction = "stop"
    }
    
    func playTimer(){
        self.isPaused = false
        self.timerAction = "start"
    }
    
    func handleResetSession(){
        self.isPaused = true
        
        let currSessionType = self.getSessionType()
        if currSessionType == SessionType.work {
            self.timerLeftS = self.workSessionDurationS
            self.timerStartS = self.workSessionDurationS
        }
        if currSessionType == SessionType.rest {
            self.timerLeftS = self.restSessionDurationS
            self.timerStartS = self.restSessionDurationS
        }
        if currSessionType == SessionType.longRest {
            self.timerLeftS = self.longRestSessionDurationS
            self.timerStartS = self.longRestSessionDurationS
        }
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
    
    // Set up
    func loadInitValues(){
        self.timerStartS = self.workSessionDurationS
        self.timerLeftS = self.workSessionDurationS
    }
}
