//
//  ModelData.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import Foundation

class ModelData: ObservableObject {
    @Published var timerStartS: Int = 3
    @Published var timerLeftS: Int = 3
    @Published var isPaused: Bool = true
    
    // Keeping track of sessions
    @Published var sessionIndex: Int = 0
    @Published var restCounter: Int = 0
    @Published var workCounter: Int = 0
    @Published var targetWorkSessions: Int = 10
    @Published var whenToLongRest: Int = 0
    
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

    

    var timerStringVal: String {
        let minutes = timerLeftS / 60 % 60
        let seconds = timerLeftS % 60
        return "\(minutes):\(seconds)"
    }
    
    var timerPctDone: Double {
        let timeElapsed = timerStartS - timerLeftS
        return Double(timeElapsed) * 100 / Double(timerStartS)
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
    
    func pauseTimer(){
        isPaused = true
        menuViewAction = "stopTimer"
    }
    
    func playTimer(){
        isPaused = false
        menuViewAction = "startTimer"
    }
    
    private func handleTimerOnZero(){
        
    }
}
