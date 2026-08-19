//
//  ContentView.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            pegs(colors: [.red, .green, .green, .yellow])
            pegs(colors: [.red, .blue, .green, .red])
            pegs(colors: [.red, .yellow, .green, .blue])
        }
        .padding()
    }
    
    func pegs(colors: Array<Color>) -> some View{
        HStack {
            ForEach(colors.indices, id: \.self) { i in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colors[i])
            }
            MatchMarker(matches:[.exact, .inexact, .nomatch, .exact])
        }
    }
}


#Preview {
    ContentView()
}
