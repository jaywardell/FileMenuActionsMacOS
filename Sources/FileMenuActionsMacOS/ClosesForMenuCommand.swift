//
//  ClosesForMenuCommand.swift
//  ImageReaderApp
//
//  Created by Joseph Wardell on 2/27/25.
//

import SwiftUI

fileprivate extension Notification.Name {
    static var windowShouldClose: Self { .init(#function) }
    static var allWindowsShouldClose: Self { .init(#function) }
}

@available(macOS 14.0, *)
struct ClosesForMenuCommand: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.controlActiveState) var controlActiveState
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .windowShouldClose)) { _ in
                guard controlActiveState != .inactive else { return }
                dismiss()
            }
            .onReceive(NotificationCenter.default.publisher(for: .allWindowsShouldClose)) { _ in
                dismiss()
            }
    }
}

@available(macOS 14.0, *)
public extension View {
    /// a modifier that will close the contining window when the user chooses a `CloseWindowButton` or `CloseAllWindowsButton`
    func closesForMenuCommand() -> some View {
        modifier(ClosesForMenuCommand())
    }
}

/// a button that sends a message to close the currently frontmost window
///
/// any window that contains a view that's modified with `closesForMenuCommand()`
/// and is the frontmost window
/// will close when this button's action is invoked
@available(macOS 14.0, *)
public struct CloseWindowButton: View {
        
    @State private var shouldDisable: Bool = false

    public var body: some View {
        Button("Close") {
            NotificationCenter.default.post(name: .windowShouldClose, object: nil)
        }
        .disabled(shouldDisable)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didUpdateNotification)) { _ in
            shouldDisable = NSApplication.shared.windows.filter(\.isVisible).isEmpty
        }
    }
}

/// a button that sends a message to close all windows
///
/// any window that contains a view that's modified with `closesForMenuCommand()`
/// will close when this button's action is invoked
@available(macOS 14.0, *)
public struct CloseAllWindowsButton: View {
    
    @State private var shouldDisable: Bool = false
    
    public var body: some View {
        Button("Close All Windows") {
            NotificationCenter.default.post(name: .allWindowsShouldClose, object: nil)
        }
        .disabled(shouldDisable)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didUpdateNotification)) { _ in
            shouldDisable = NSApplication.shared.windows.filter(\.isVisible).isEmpty
        }
    }
}
