//
//  press_n_catchApp.swift
//  press n catch
//
//  Created by yuteng Lan on 5/9/2024.
//

import SwiftUI

@main
struct press_n_catchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Record.self)
        }
    }
}
