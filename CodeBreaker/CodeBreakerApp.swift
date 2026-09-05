//
//  CodeBreakerApp.swift
//  CodeBreaker
//
//  Created by HUAWEI MateBook X on 2026/8/18.
//

import SwiftUI
import SwiftData

@main
struct CodeBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
