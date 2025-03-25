//
//  ShowInFinderAction.swift
//  Image Reader
//
//  Created by Joseph Wardell on 3/24/25.
//

import SwiftUI

/// an action that can be used to show the url passed in in the Finder, assuming that the url represents a file utl
///
/// call an instance of this action as a function to switch to the Finder and show the location of the url passed in
@available(macOS 14.0, *)
@MainActor
public struct ShowInFinderAction {
    @MainActor public func callAsFunction(url: URL) {
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

@available(macOS 14.0, *)
public extension EnvironmentValues {

    /// an instance of `ShowInFinderAction` that's been passed down the environment
    @Entry var showInFinder: ShowInFinderAction?
}

/// a view modifier that passes an instance of `ShowInFinderAction` down the environment
@available(macOS 14.0, *)
public extension View {
    func canShowFilesInFinder() -> some View {
        environment(\.showInFinder, ShowInFinderAction())
    }
}
