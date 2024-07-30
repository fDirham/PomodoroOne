//
//  CircleTimerView.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import SwiftUI

struct CircleTimerView: View {
    var size: Double
    var lineWidth: Double
    var knobSize: Double
    var pctDone: Double
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: lineWidth)
            .frame(width: size, height: size)
            .overlay{
                CircleTimerArc(pctDone: pctDone, diameter: size - lineWidth)
                    .stroke(.ourOrange, lineWidth: lineWidth)
            }
            .overlay{
                CircleTimerKnob(
                diameter: size, knobDiameter: knobSize, pctDone: pctDone
                )
            }
    }
}

#Preview {
    CircleTimerView(size: 122.0, lineWidth: 6, knobSize: 15, pctDone: 50)
}
