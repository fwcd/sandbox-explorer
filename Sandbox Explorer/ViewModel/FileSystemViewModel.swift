//
//  FileSystemViewModel.swift
//  Sandbox Explorer
//
//  Created on 02.11.23
//

import Foundation
import OSLog

private let log = Logger(subsystem: "Sandbox Explorer", category: "FileSystemViewModel")

class FileSystemViewModel: ObservableObject {
    @Published var useSecurityScopedBookmarks = false
    @Published var listDirectoriesViaUrl = true
    @Published var resolveSymlinks = true
    
    func lookup(url: URL, trySecurityScopedAccess: Bool = true) -> FileNode {
        do {
            let fileManager = FileManager.default
            
            if resolveSymlinks, let destination = try? fileManager.destinationOfSymbolicLink(atPath: url.path) {
                return .symlink(url: url, destination: URL(filePath: destination))
            }
            
            var isDir: ObjCBool = false
            _ = fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
            
            if isDir.boolValue {
                var children: [URL]
                if listDirectoriesViaUrl {
                    children = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
                } else {
                    children = try fileManager.contentsOfDirectory(atPath: url.path).map { URL(filePath: $0) }
                }
                children.sort { $0.lastPathComponent < $1.lastPathComponent }
                return .directory(url: url, children: children)
            }
            
            let attributes = try fileManager.attributesOfItem(atPath: url.path())
            guard let size = attributes[.size] as? UInt64 else {
                return .file(url: url, bytes: nil)
            }
            
            return .file(url: url, bytes: Int(size))
        } catch {
            do {
                securityScope:
                if trySecurityScopedAccess && useSecurityScopedBookmarks {
                    let bookmark = try url.bookmarkData(options: .withSecurityScope)
                    guard !bookmark.isEmpty else {
                        log.warning("Could not create bookmark")
                        break securityScope
                    }
                    var stale = false
                    let url = try URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &stale)
                    guard url.startAccessingSecurityScopedResource() else {
                        log.warning("Could not start accessing security-scoped resource")
                        break securityScope
                    }
                    defer {
                        url.stopAccessingSecurityScopedResource()
                    }
                    var error: NSError? = nil
                    var fileNode: FileNode? = nil
                    NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { newUrl in
                        fileNode = lookup(url: newUrl, trySecurityScopedAccess: false)
                    }
                    if let error {
                        log.warning("Could not coordinate read: \(error)")
                    }
                    if let fileNode {
                        return fileNode
                    }
                }
            } catch {
                return .inaccessible(url: url, reason: error.localizedDescription)
            }
            return .inaccessible(url: url, reason: error.localizedDescription)
        }
    }
}
