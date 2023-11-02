//
//  ContentView.swift
//  SandboxExplorer
//
//  Created on 02.11.23
//

import SwiftUI

struct ContentView: View {
    @State private var isInspectorShown = true
    
    var body: some View {
        NavigationStack {
            FileSystemView()
                .inspector(isPresented: $isInspectorShown) {
                    Text("TODO")
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("Inspector", systemImage: "sidebar.right") {
                            isInspectorShown = !isInspectorShown
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
