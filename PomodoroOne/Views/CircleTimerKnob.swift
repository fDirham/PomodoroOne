//
//  CircleTimerKnob.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import SwiftUI

struct CircleTimerKnob: View {
    let diameter: Double
    let knobDiameter: Double
    let pctDone: Double
    
    private var bigCircleDiameter: Double {
        diameter + (knobDiameter / 2.0)
    }
    
    private var rotationAngle: Angle {
        Angle(degrees: 360.0 * pctDone / 100.0)
    }
    
    var body: some View {
            HStack{
                Spacer()
                Circle()
                    .frame(width: knobDiameter, height: knobDiameter)
                    .foregroundStyle(.ourOrange)
            }
            .frame(width: bigCircleDiameter, height: bigCircleDiameter)
            .rotationEffect(rotationAngle)
        }
}

#Preview {
    CircleTimerKnob(diameter: 100, knobDiameter: 20, pctDone: 12.5)
}
