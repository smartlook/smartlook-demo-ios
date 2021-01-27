//
//  SwiftUI+Smartlook.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 14.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import SwiftUI
import Smartlook

// MARK: - Sensitive modifier

extension View {
    func smartlookSensitive(enabled: Bool = true) -> some View {
        self.modifier(SmartlookSensitiveModifier(enabled: enabled))
    }
}

struct SmartlookSensitiveModifier: ViewModifier {
    let enabled: Bool

    func body(content: Content) -> some View {
        content
            .background(SmartlookSensitiveView(enabled: enabled))
    }
}

private struct SmartlookSensitiveView: UIViewRepresentable {
    var enabled: Bool = true

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.slSensitive = enabled
    }
}

struct SmartlookSensitive<Content: View>: View {
    let enabled: Bool
    let content: Content

    init(enabled: Bool = true, @ViewBuilder content: () -> Content) {
        self.enabled = enabled
        self.content = content()
    }

    var body: some View {
        content
            .smartlookSensitive(enabled: enabled)
    }
}


// MARK: - Event tracking modifier

extension View {
    func smartlookTrackEvent(name: String, params: [String: String], enabled: Bool = true) -> some View {
        self.modifier(SmartlookTrackEventModifier(eventName: name, params: params, enabled: enabled))
    }

    func smartlookTrackEvent(name: String, param: String? = nil, enabled: Bool = true) -> some View {
        var params: [String: String]?
        if let param = param {
            params = ["value": param]
        }

        return self.modifier(SmartlookTrackEventModifier(eventName: name, params: params, enabled: enabled))
    }
}

struct SmartlookTrackEventModifier: ViewModifier {
    let eventName: String
    let params: [String: String]?
    let enabled: Bool

    func body(content: Content) -> some View {
        content.simultaneousGesture(TapGesture().onEnded({
            if enabled {
                 Smartlook.trackCustomEvent(name: eventName, props: params)
            }
        }))
    }
}
