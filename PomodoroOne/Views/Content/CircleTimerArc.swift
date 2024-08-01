//
//  CircleTimerArc.swift
//  PomodoroOne
//
//  Created by Fajar Dirham on 7/30/24.
//

import SwiftUI

struct CircleTimerArc: Shape {
    let pctDone: Double
    let diameter: Double
    
    private let startAngle = Angle(degrees: 0)
    
    private var endAngle: Angle {
        Angle(degrees: 360.0 * pctDone / 100)
    }
    
    func path(in rect: CGRect) -> Path {
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}

#Preview {
    CircleTimerArc(pctDone: 87, diameter: 34)
        .stroke(.red, lineWidth: 12)
}
