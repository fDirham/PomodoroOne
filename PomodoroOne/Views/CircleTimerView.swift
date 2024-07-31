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
    var activeColor: Color
    
    var realPctDone: Double {
        if pctDone < 100.0 {
         return pctDone   
        }
            return 100.0
    }
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: lineWidth)
            .frame(width: size, height: size)
            .overlay{
                CircleTimerArc(pctDone: realPctDone, diameter: size - lineWidth)
                    .stroke(activeColor, lineWidth: lineWidth)
                    .rotationEffect(Angle(degrees: -90))
            }
            .overlay{
                CircleTimerKnob(
                diameter: size, knobDiameter: knobSize, pctDone: realPctDone, knobColor: activeColor
                )
                .rotationEffect(Angle(degrees: -90))
            }
    }
}

#Preview {
    CircleTimerView(size: 122.0, lineWidth: 6, knobSize: 15, pctDone: 50, activeColor: .work)
}
