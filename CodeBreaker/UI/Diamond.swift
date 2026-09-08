//
//  Diamond.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/9/8.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.midX,y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX,y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX,y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX,y: rect.midY))
            path.closeSubpath()
        }
    }
    
    
}

#Preview {
    Diamond().stroke().aspectRatio(contentMode: .fit)
}
