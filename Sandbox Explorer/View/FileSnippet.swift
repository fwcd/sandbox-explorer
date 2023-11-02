//
//  FileSnippet.swift
//  SandboxTest
//
//  Created on 02.11.23
//

import SwiftUI

struct FileSnippet: View {
    let node: FileNode
    var isRoot: Bool = false
    var isLinked: Bool = false
    
    private var formattedSize: String? {
        guard case let .file(_, bytes?) = node else { return nil }
        var units = ["B", "kB", "MB", "GB", "TB"]
        var current = Double(bytes)
        while Int(current) / 1000 != 0 && units.count > 1 {
            units.removeFirst()
            current /= 1000
        }
        return "\(String(format: "%.2f", current)) \(units[0])"
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text(isRoot ? node.path : node.name)
            Spacer()
            if let formattedSize {
                Text(formattedSize)
            }
            if case let .inaccessible(_, reason) = node {
                Text(reason)
                    .textSelection(.enabled)
            }
        }
        .foregroundStyle(node.isAccessible ? .primary : .tertiary)
        .foregroundStyle(isLinked ? Color(red: 0.6, green: 1, blue: 1) : .primary)
        .contextMenu {
            #if os(macOS)
            Button("Show in Finder") {
                NSWorkspace.shared.selectFile(node.path, inFileViewerRootedAtPath: node.path)
            }
            Divider()
            #endif
            Button("Copy Name") {
                setPasteboard(node.name)
            }
            Button("Copy Path") {
                setPasteboard(node.path)
            }
            Button("Copy URL") {
                setPasteboard(node.url.absoluteString)
            }
        }
    }
}

#Preview {
    VStack {
        FileSnippet(node: .file(url: URL(filePath: "Test"), bytes: 3))
        FileSnippet(node: .file(url: URL(filePath: "Large"), bytes: 3_800_000))
    }
}
