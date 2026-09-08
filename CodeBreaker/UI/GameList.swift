//
//  GameList.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/9/4.
//

import SwiftUI
import SwiftData

struct GameList: View {
    // MARK: Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: Data Owned by Me
    @State private var gameToEdit: CodeBreaker?
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    @Query private var games: [CodeBreaker] = []
    
    init(sortBy: SortOption = .name, nameContains search: String = "", selection: Binding<CodeBreaker?>) {
        _selection = selection
        let lowercaseSearch = search.lowercased()
        let capitalizedSearch = search.capitalized
        let completeedOnly = sortBy == .completed
        let predicate = #Predicate<CodeBreaker> { game in
            (!completeedOnly || game.isOver) &&
            (search.isEmpty || game.name.contains(lowercaseSearch) || game.name.contains(capitalizedSearch))
        }
        switch sortBy {
        case .name: _games = Query(filter: predicate, sort: \CodeBreaker.name)
        case .recent, .completed: _games = Query(filter: predicate, sort: \CodeBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable{
        case name
        case recent
        case completed
        
        var title: String {
            switch self {
            case .name: "Sort by Name"
            case .recent: "Recent"
            case . completed: "Completed"
            }
        }
    }
    
    var summarySize: GameSummary.Size {
        staticSummarySize * dynamicSummarySizeMagnification
    }
    
    @State private var staticSummarySize: GameSummary.Size = .large
    
    @State private var dynamicSummarySizeMagnification: CGFloat = 1.0
    
    
    
    var body: some View {
        List(selection: $selection) {
            ForEach (games) { game in
                NavigationLink(value: game){
                    GameSummary(game: game, size: summarySize)
                }
                .contextMenu {
                    editButton(for: game)// editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game)
                        .tint(.blue)
                }
            }
            .onDelete { offsets in
                for offset in offsets{
                    modelContext.delete(games[offset])
                }
            }
        }
        .highPriorityGesture(summarySizeMagnifier)
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing the List of games
        }
        
        .onAppear {
            Task {
                await addSampleGames()
            }
        }
    }
    
    var summarySizeMagnifier: some Gesture {
        MagnifyGesture()
            .onChanged{ value in
                dynamicSummarySizeMagnification = value.magnification
            }
            .onEnded { value in
                staticSummarySize = staticSummarySize * value.magnification
                dynamicSummarySizeMagnification = 1.0
            }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "plus"){
            gameToEdit = game
        }
    }
    
    var addButton: some View{
        Button("Add Game", systemImage: "plus"){
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [.red, .blue])
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View{
        if let gameToEdit{
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices:  gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if games.contains(gameToEdit){
                    modelContext.delete(gameToEdit)
                }
                modelContext.insert(copyOfGameToEdit)
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool>(get:{
            gameToEdit != nil
        },
                      set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        })
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func addSampleGames() async {
        let fetchDescriptor = FetchDescriptor<CodeBreaker>()
        if let results = try? modelContext.fetchCount(fetchDescriptor), results == 0{
            for url in sampleGameURLs {
                do {
                    let (json, _) = try await URLSession.shared.data(from: url)
                    let game = try JSONDecoder().decode(CodeBreaker.self , from: json)
                    modelContext.insert(game)
                    print("loaded sample game from \(url)")
                } catch {
                    print("couldn't load sample game from json file at \(url): \(error.localizedDescription)")
                }
            }
        }
    }
    
    var sampleGameURLs: [URL] {
        Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
            .map { URL(fileURLWithPath: $0) }
    }
}

extension GameSummary.Size {
    static func *(lhs: Self, rhs: CGFloat) -> Self {
        switch rhs {
        case 2.0...: lhs.larger.larger
        case 1.5...: lhs.larger
        case ...0.35: lhs.smaller.smaller
        case ...0.5: lhs.smaller
        default: lhs
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
