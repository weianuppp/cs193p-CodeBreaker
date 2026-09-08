//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/20.
//

import Foundation
import SwiftData

typealias Peg = String

@Model class CodeBreaker: Decodable {
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade, inverse: \Code.game) var _attempts = [Code]()
    var pegChoices: [Peg]
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false
    
    var attempts: [Code] {
        get { _attempts.sorted{ $0.timestamp > $1.timestamp }}
        set { _attempts = newValue }
    }
    
    init(name: String = "Code Breaker", pegChoices: [Peg]){
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func attempGuess(){
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(
            kind: .attempt(guess.match(against: masterCode)),
            pegs: guess.pegs
        )
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
        guess.reset()
        if attempts.first?.pegs == masterCode.pegs{
            isOver = true
            masterCode.kind = .master(isHidden: false)
            endTime = .now
            pauseTimer()
        }
    }
    
    func setGuessPeg( _ peg: Peg , at index: Int){
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func changeGuessPeg(at index: Int){
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg){
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        }else{
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }

    // MARK: - Decodable

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let pegChoices = try container.decode([Peg].self, forKey: .pegChoices)
        self.init(name: name, pegChoices: pegChoices)
        masterCode = try container.decode(CodeSnapshot.self, forKey: .masterCode).makeCode()
        guess = try container.decode(CodeSnapshot.self, forKey: .guess).makeCode()
        attempts = try container.decode([CodeSnapshot].self, forKey: .attempts).map { $0.makeCode() }
        startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
        endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        elapsedTime = try container.decode(TimeInterval.self, forKey: .elapsedTime)
        lastAttemptDate = try container.decodeIfPresent(Date.self, forKey: .lastAttemptDate)
        isOver = try container.decode(Bool.self, forKey: .isOver)
    }
    
}
