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
    
    var node: FileNode {
        FileNode.at(url: url)
    }
    
    var body: some View {
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
}
