//
//  PegView.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/23.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    var body: some View {
        pegShape
            .overlay{
                if peg == Code.missingPeg{
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
    
}

#Preview {
    PegView(peg: .blue)
        .padding()
}
