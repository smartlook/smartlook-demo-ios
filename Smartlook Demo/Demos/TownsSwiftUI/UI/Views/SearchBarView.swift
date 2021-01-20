//
//  SearchBarView.swift
//  Smartlook Demo App
//
//  Created by Václav Halík on 30.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var text: String
    var onCommit: () -> Void = {}

    @State private var isEditing: Bool = false

    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $text, onEditingChanged: { _ in
                    isEditing = true
                }, onCommit: onCommit)
                .padding(8)
                .padding(.leading, 24)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, 7)

                        Spacer()

                        if isEditing {
                            Button(action: {
                                text = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .opacity(text == "" ? 0 : 1)
                                    .padding(.trailing, 8)
                            })
                        }
                    }
                    .foregroundColor(.secondary)
                )
                .onTapGesture {
                    isEditing = true
                }

                if isEditing {
                    Button("Cancel") {
                        cancelButtonPressed()
                    }
                    .padding(.vertical, 7)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)

            Divider()
                .opacity(isEditing ? 1 : 0)
        }
        .navigationBarHidden(isEditing)
        .animation(.default)
    }


    // MARK: - UI Actions

    private func cancelButtonPressed() {
        // Hide keyboard
        UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first?.endEditing(true)

        text = ""
        isEditing = false
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant("Text"))
    }
}
