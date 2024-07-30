//
//  ModelData.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import Foundation

class ModelData: ObservableObject {
    @Published var timerStartS: Int = 20
    @Published var timerLeftS: Int = 20
    @Published var isPaused: Bool = true

    var timerStringVal: String {
        let minutes = timerLeftS / 60 % 60
        let seconds = timerLeftS % 60
        return "\(minutes):\(seconds)"
    }
    
    var timerPctDone: Double {
        let timeElapsed = timerStartS - timerLeftS
        return Double(timeElapsed) * 100 / Double(timerStartS)
    }
}
