//
//  GameChooser.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/9/3.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    
    @State private var selection: CodeBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
                .navigationTitle("Code Breaker")
                .navigationBarTitleDisplayMode(.large)
        }
        detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            }else{
                Text("Choose a game")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    GameChooser()
}
