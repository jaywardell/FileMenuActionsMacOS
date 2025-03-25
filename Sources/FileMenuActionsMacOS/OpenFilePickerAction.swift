//
//  OpenFilePickerAction.swift
//  ImageReaderApp
//
//  Created by Joseph Wardell on 2/27/25.
//

import SwiftUI

/// an action that can be used to open the file picker in a document-based app
///
/// call an instance of this action as a function to bring up the file picker the same way it would come up if you chose `File->Open…`
@available(macOS 14.0, *)
@MainActor
public struct OpenFilePickerAction {
    
    public init() {}
    
    @MainActor public func callAsFunction() {
        NSApplication.shared.sendAction(#selector(NSDocumentController.openDocument(_:)), to: nil, from: nil)
    }
}

@available(macOS 14.0, *)
public extension EnvironmentValues {
    
    /// an instance of `OpenFilePickerAction` that's been passed down the environment
    @Entry var openFilePicker: OpenFilePickerAction?
}

/// a view modifier that passes an instance of `OpenFilePickerAction` down the environment
@available(macOS 14.0, *)
public extension View {
    func canOpenFilePicker() -> some View {
        environment(\.openFilePicker, OpenFilePickerAction())
    }
}

/// a button that triggers the opening of the file picker in a document based SwiftUI app
///
/// when this button is pressed, it invokes the file picker in the same way that choosing `File->Open…` does
@available(macOS 14.0, *)
public struct FilePickerButton: View {
    
    let title: String
    let systemImage: String?
    
    public init(title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }
    
    @Environment(\.openFilePicker) var openFilePicker

    public var body: some View {
        Button(action: buttonPressed) {
            Label(title, systemImage: systemImage ?? "")
        }
    }
    
    private func buttonPressed() {
        openFilePicker?()
    }
}
