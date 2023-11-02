//
//  FileSystemUtils.swift
//  SandboxTest
//
//  Created on 02.11.23
//

import Foundation

enum FileNode {
    case file(url: URL, bytes: Int?)
    case directory(url: URL, children: [URL])
    case inaccessible(url: URL, reason: String)
    
    var url: URL {
        switch self {
        case .file(let url, _): url
        case .directory(let url, _): url
        case .inaccessible(let url, _): url
        }
    }
    
    var path: String {
        url.path
    }
    
    var name: String {
        url.lastPathComponent
    }
    
    static func at(url: URL) -> FileNode {
        let fileManager = FileManager.default
        
        do {
            var isDir: ObjCBool = false
            let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
            guard exists else {
                return .inaccessible(url: url, reason: "Non-existent")
            }
            
            if isDir.boolValue {
                let contents = try fileManager.contentsOfDirectory(atPath: url.path)
                return .directory(url: url, children: contents.map { URL(filePath: $0) })
            }
            
            let attributes = try fileManager.attributesOfItem(atPath: url.path())
            guard let size = attributes[.size] as? UInt64 else {
                return .file(url: url, bytes: nil)
            }
            
            return .file(url: url, bytes: Int(size))
        } catch {
            return .inaccessible(url: url, reason: String(describing: error))
        }
    }
}
