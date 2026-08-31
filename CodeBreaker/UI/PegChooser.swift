//
//  pegChooser.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/23.
//

import SwiftUI

struct PegChooser: View {
    
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    // MARK: - Body
    
    var body: some View {
    
            HStack{
                ForEach(choices, id: \.self) { peg in
                    Button{
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
        
    }
}

