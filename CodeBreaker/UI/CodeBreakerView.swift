//
//  ContentView.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/18.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black, .green])
    @State private var selection: Int = 0
    
    // MARK: - Body
    
    var body: some View {
        
        VStack{
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver{
                    CodeView(code: game.guess, selection: $selection){
                        guessButton
                    }
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index]){
                            if let matches = game.attempts[index].matches {
                                MatchMarker(matches: matches)
                            }
                    }
                }
            }
            PegChooser(choices: game.pegChoices){ peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }   
        }
        .padding()
    }
    
    
    
    var guessButton: some View{
        Button("Guess"){
            withAnimation {
                game.attempGuess()
                selection = 0
            }
        }
        .font(.system(size: GuessButton.maximunFontSize))
        .minimumScaleFactor(GuessButton.scaleFactor)
    }
    
    
    
    struct GuessButton {
        static let minimunFontSize: CGFloat = 8
        static let maximunFontSize: CGFloat = 80
        static let scaleFactor = minimunFontSize / maximunFontSize
    }

}

extension Color{
    static func gray(_ brightness: CGFloat) -> Color{
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}


#Preview {
    CodeBreakerView()
}
