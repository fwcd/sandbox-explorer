//
//  Pasteboard.swift
//  Sandbox Explorer
//
//  Created on 02.11.23
//

#if canImport(AppKit)
import AppKit

func setPasteboard(_ text: String) {
    let pb = NSPasteboard.general
    pb.clearContents()
    pb.setString(text, forType: .string)
}
#elseif canImport(UIKit)
import UIKit

func setPasteboard(_ text: String) {
    UIPasteboard.general.string = text
}
#else
#error("Either AppKit or UIKit is needed")
#endif
