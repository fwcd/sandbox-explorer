//
//  FileSystemUtils.swift
//  SandboxTest
//
//  Created on 02.11.23
//

import Foundation

enum FileNode {
    case loading(url: URL)
    case file(url: URL, bytes: Int?)
    case directory(url: URL, children: [URL])
    case symlink(url: URL, destination: URL)
    case inaccessible(url: URL, reason: String)
    
    var url: URL {
        switch self {
        case .loading(let url): url
        case .file(let url, _): url
        case .directory(let url, _): url
        case .symlink(let url, _): url
        case .inaccessible(let url, _): url
        }
    }
    
    var path: String {
        url.path
    }
    
    var name: String {
        url.lastPathComponent
    }
    
    var isAccessible: Bool {
        switch self {
        case .loading(_): false
        case .inaccessible(_, _): false
        default: true
        }
    }
}
