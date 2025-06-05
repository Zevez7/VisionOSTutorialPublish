//
//  RotateButton.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/9/25.
//

import SwiftUI

struct RotateButton: View {

    @Environment(ARClass.self) var arClass
    @Environment(MenuClass.self) var menuClass

    var body: some View {

        let selectedModel = menuClass.selectedModel

        Button {

            menuClass
                .rotate(
                    entity:
                        menuClass
                        .modelStore[selectedModel]!,
                    yrotation: -1
                )
            menuClass
                .rotate(
                    entity:
                        arClass
                        .modelStore[selectedModel]!,
                    yrotation: -1
                )
        } label: {
            Image(systemName: "arrowshape.turn.up.left.fill")
                .font(
                    .system(size: 35))
        }.padding()
            .disabled(menuClass.buttonDisable)
            .background(menuClass.buttonDisable ? .red.opacity(0.01) : .clear)
            .cornerRadius(10)

        Text("ROTATE")

        Button {
            menuClass
                .rotate(
                    entity:
                        menuClass
                        .modelStore[selectedModel]!
                )
            menuClass
                .rotate(
                    entity:
                        arClass
                        .modelStore[selectedModel]!
                )

        } label: {

            Image(systemName: "arrowshape.turn.up.right.fill")
                .font(
                    .system(size: 35))
        }.padding()
            .disabled(menuClass.buttonDisable)
            .background(menuClass.buttonDisable ? .red.opacity(0.01) : .clear)
            .cornerRadius(10)
    }
}
