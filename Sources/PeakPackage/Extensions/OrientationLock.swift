//
//  OrientationLock.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/9/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

struct SupportedOrientationsPreferenceKey: PreferenceKey {
    typealias Value = UIInterfaceOrientationMask
    static var defaultValue: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscape
        }
        else {
            return .allButUpsideDown
        }
    }

    static func reduce(value: inout UIInterfaceOrientationMask, nextValue: () -> UIInterfaceOrientationMask) {
        // use the most restrictive set from the stack
        value.formIntersection(nextValue())
    }
}

/// Use this in place of `UIHostingController` in your app's `SceneDelegate`.
///
/// Supported interface orientations come from the root of the view hierarchy.
class OrientationLockedController<Content: View>: UIHostingController<OrientationLockedController.Root<Content>> {
    class Box {
        var supportedOrientations: UIInterfaceOrientationMask
        init() {
            self.supportedOrientations =
                UIDevice.current.userInterfaceIdiom == .pad
                    ? .all
                    : .allButUpsideDown
        }
    }

    var orientations: Box!
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientations.supportedOrientations
    }
    
    var root : Content?
    init(rootView: Content) {
        let box = Box()
        root = rootView
        let orientationRoot = Root(contentView: rootView, box: box)
        super.init(rootView: orientationRoot)
        self.orientations = box
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    struct Root<Content: View>: View {
        let contentView: Content
        let box: Box

        var body: some View {
            contentView
                .onPreferenceChange(SupportedOrientationsPreferenceKey.self) { value in
                    // Update the binding to set the value on the root controller.
                    self.box.supportedOrientations = value
            }
        }
    }
}

extension View {
    func supportedOrientations(_ supportedOrientations: UIInterfaceOrientationMask) -> some View {
        // When rendered, export the requested orientations upward to Root
        preference(key: SupportedOrientationsPreferenceKey.self, value: supportedOrientations)
    }
}
