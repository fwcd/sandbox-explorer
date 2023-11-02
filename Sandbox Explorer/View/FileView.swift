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
    
    var node: FileNode {
        FileNode.at(url: url)
    }
    
    var body: some View {
        switch node {
        case .directory(_, let children):
            DisclosureGroup {
                ForEach(children, id: \.self) { childUrl in
                    FileView(url: childUrl, isRoot: false)
                }
            } label: {
                FileSnippet(node: node, fullPath: isRoot)
            }
        case _:
            FileSnippet(node: node, fullPath: isRoot)
        }
    }
}
