//
//  ContentView.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/18.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // MARK: Data Share with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    
    var body: some View {
        
        VStack{
            CodeView(code: game.masterCode){
            }
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection){
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt){
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches {
                            MatchMarker(matches: matches)
                        }
                    }
                    .transition(
                        .attempt(game.isOver)
                    )
                }
            }
            if !game.isOver {
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelectionToPeg)
                    .transition(.pegChooser)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction){
                Button("Restart", systemImage: "arrow.circlepath",action: restart)
            }
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime:game.endTime)
                    .monospaced()
                    .lineLimit(1)
            }
        }
        .padding()
    }
    
    func changePegAtSelectionToPeg(to peg: Peg){
            game.setGuessPeg(peg, at: selection)
            selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    
    
    func guess(){
        withAnimation(.guess) {
            game.attempGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess){
                hideMostRecentMarkers = false
            }
        }
    }
    
    func restart() {
        withAnimation(.restart){
            restarting = game.isOver
        } completion: {
            withAnimation(.restart){
                game.restart()
                selection = 0
                restarting = false
            }
        }
    }
    
}




#Preview {
    @Previewable @State  var game = CodeBreaker(name: "Preview", pegChoices: [.blue, .red, .orange])
    NavigationStack{
        CodeBreakerView(game: game)
    }
}
