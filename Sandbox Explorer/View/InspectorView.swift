//
//  InspectorView.swift
//  Sandbox Explorer
//
//  Created on 02.11.23
//

import SwiftUI

struct InspectorView: View {
    @EnvironmentObject private var fileSystem: FileSystemViewModel
    
    var body: some View {
        Form {
            Section("Options") {
                Toggle(isOn: $fileSystem.useSecurityScopedBookmarks) {
                    Text("Use Security-Scoped Bookmarks")
                }
                Toggle(isOn: $fileSystem.resolveSymlinks) {
                    Text("Resolve Symlinks")
                }
            }
        }
    }
}

#Preview {
    InspectorView()
        .environmentObject(FileSystemViewModel())
}
