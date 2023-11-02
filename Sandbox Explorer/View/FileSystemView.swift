//
//  FileSystemView.swift
//  Sandbox Explorer
//
//  Created on 02.11.23
//

import SwiftUI

struct FileSystemView: View {
    var body: some View {
        List {
            Section("Root Directory") {
                FileView(url: URL(filePath: "/"))
            }
            Section("Home Directory") {
                FileView(url: URL.homeDirectory)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .navigationDocument(URL.homeDirectory)
    }
}

#Preview {
    FileSystemView()
}
