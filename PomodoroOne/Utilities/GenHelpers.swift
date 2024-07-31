//
//  File.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/31/24.
//

import SwiftUI

class GenHelpers{
    static let isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
