//
//  SandboxExplorerApp.swift
//  SandboxExplorer
//
//  Created on 02.11.23
//

import SwiftUI

@main
struct SandboxExplorerApp: App {
    @StateObject private var fileSystem = FileSystemViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fileSystem)
        }
    }
}
