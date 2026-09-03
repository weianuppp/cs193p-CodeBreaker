//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/9/3.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices, onChoose: nil)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count + 1) attempt](inflect: true)")
        }
    }
}

#Preview {
    List{
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red,.cyan,.yellow]))
    }
    List{
        GameSummary(game: CodeBreaker(name: "Preview", pegChoices: [.red,.cyan,.yellow]))
    }
    .listStyle(.plain)
}
