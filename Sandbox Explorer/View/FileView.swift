//
//  FileView.swift
//  SandboxTest
//
//  Created on 02.11.23
//

import SwiftUI

struct FileView: View {
    let url: URL
    var isRoot: Bool = true
    var isLinked: Bool = false
    
    @EnvironmentObject private var fileSystem: FileSystemViewModel
    @State private var isRefreshing: Bool = false
    @State private var resolvedNode: FileNode? = nil
    
    private var node: FileNode {
        resolvedNode ?? .loading(url: url)
    }
    
    var body: some View {
        Group {
            switch node {
            case .directory(_, let children):
                DisclosureGroup {
                    ForEach(children, id: \.self) { childUrl in
                        FileView(url: childUrl, isRoot: false, isLinked: false)
                    }
                } label: {
                    FileSnippet(node: node, isRoot: isRoot, isLinked: isLinked)
                }
            case .symlink(_, let destination):
                FileView(url: destination, isRoot: false, isLinked: true)
            case _:
                FileSnippet(node: node, isRoot: isRoot, isLinked: isLinked)
            }
        }
        .opacity(isRefreshing ? 0.8 : 1)
        .onAppear {
            if resolvedNode == nil {
                refresh()
            }
        }
        .onReceive(fileSystem.objectWillChange) {
            refresh()
        }
    }
    
    private func refresh() {
        isRefreshing = true
        Task {
            let resolvedNode = fileSystem.lookup(url: url)
            Task.detached { @MainActor in
                self.resolvedNode = resolvedNode
                isRefreshing = false
            }
        }
    }
}
