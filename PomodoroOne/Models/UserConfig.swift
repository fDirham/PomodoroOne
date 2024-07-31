//
//  UserConfig.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/31/24.
//

import Foundation

struct UserConfig: Codable {
    let workDurationS: Int
    let restDurationS: Int
    let longRestDurationS: Int
    let whenToLongRest: Int
    let targetWorkSessions: Int
    
    let autoPlay: Bool
    let overtimeAllowed: Bool
}
