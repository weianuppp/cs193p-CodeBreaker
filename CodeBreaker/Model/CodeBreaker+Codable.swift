//
//  CodeBreaker+Codable.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/9/8.
//

import Foundation

// MARK: - Encodable

// SwiftData (@Model) classes are not Codable automatically,
// so both directions are implemented manually here.
extension CodeBreaker: Encodable {
    enum CodingKeys: String, CodingKey {
        case name
        case masterCode
        case guess
        case attempts
        case pegChoices
        case startTime
        case endTime
        case elapsedTime
        case lastAttemptDate
        case isOver
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(CodeSnapshot(code: masterCode), forKey: .masterCode)
        try container.encode(CodeSnapshot(code: guess), forKey: .guess)
        var attemptSnapshots: [CodeSnapshot] = []
        for attempt in attempts {
            attemptSnapshots.append(CodeSnapshot(code: attempt))
        }
        try container.encode(attemptSnapshots, forKey: .attempts)
        try container.encode(pegChoices, forKey: .pegChoices)
        try container.encodeIfPresent(startTime, forKey: .startTime)
        try container.encodeIfPresent(endTime, forKey: .endTime)
        try container.encode(elapsedTime, forKey: .elapsedTime)
        try container.encodeIfPresent(lastAttemptDate, forKey: .lastAttemptDate)
        try container.encode(isOver, forKey: .isOver)
    }
}

// MARK: - Snapshot

// Code is also a SwiftData model and not Codable, so it is converted to and
// from this lightweight value snapshot for JSON encoding/decoding.
struct CodeSnapshot: Codable {
    let kind: String
    let pegs: [Peg]
    let timestamp: Date
    let matches: [String]?

    init(code: Code) {
        kind = code.kind.description
        pegs = code.pegs
        timestamp = code.timestamp
        matches = code.matches?.map(\.rawValue)
    }

    func makeCode() -> Code {
        let code = Code(kind: Kind(kind), pegs: pegs)
        code.timestamp = timestamp
        return code
    }
}
