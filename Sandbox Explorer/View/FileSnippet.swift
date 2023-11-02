//
//  FileSnippet.swift
//  SandboxTest
//
//  Created on 02.11.23
//

import SwiftUI

struct FileSnippet: View {
    let node: FileNode
    var fullPath: Bool = false
    
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
        HStack {
            Text(fullPath ? node.path : node.name)
            Spacer()
            if let formattedSize {
                Text(formattedSize)
            }
            if case let .inaccessible(_, reason) = node {
                Text("Inaccessible: \(reason)")
                    .textSelection(.enabled)
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
