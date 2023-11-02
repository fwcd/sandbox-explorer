//
//  FileSystemViewModel.swift
//  Sandbox Explorer
//
//  Created on 02.11.23
//

import Foundation

class FileSystemViewModel: ObservableObject {
    func lookup(url: URL) -> FileNode {
        let fileManager = FileManager.default
        
        if let destination = try? fileManager.destinationOfSymbolicLink(atPath: url.path) {
            return .symlink(url: url, destination: URL(filePath: destination))
        }
            
        do {
            var isDir: ObjCBool = false
            _ = fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
            
            if isDir.boolValue {
                let children = try fileManager.contentsOfDirectory(atPath: url.path)
                    .sorted()
                    .map { URL(filePath: $0) }
                return .directory(url: url, children: children)
            }
            
            let attributes = try fileManager.attributesOfItem(atPath: url.path())
            guard let size = attributes[.size] as? UInt64 else {
                return .file(url: url, bytes: nil)
            }
            
            return .file(url: url, bytes: Int(size))
        } catch {
            return .inaccessible(url: url, reason: error.localizedDescription)
        }
    }
}
