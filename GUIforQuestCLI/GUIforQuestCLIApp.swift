//
//  GUIforQuestCLIApp.swift
//  GUIforQuestCLI
//
//  Created by Benjamin Lucas on 2/28/23.
//

import SwiftUI

@main
struct GUIforQuestCLIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizabilityContentSize()
    }
}


extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
