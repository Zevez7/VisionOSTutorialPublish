//
//  RotateButton.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/9/25.
//

import SwiftUI

struct ScaleButton: View {

    @Environment(ARClass.self) var arClass
    @Environment(MenuClass.self) var menuClass

    var body: some View {

        let selectedModel = menuClass.selectedModel

        Button {
            menuClass
                .scale(
                    entity:
                        arClass
                        .modelStore[selectedModel]!,
                    isScalingUp: false
                )
        } label: {
            Image(systemName: "minus").font(
                .system(size: 40))
        }.padding()
            .disabled(menuClass.buttonDisable)
            .background(menuClass.buttonDisable ? .red.opacity(0.01) : .clear)
            .cornerRadius(10)

        Text("SCALE")
        Button {
            menuClass
                .scale(
                    entity: arClass.modelStore[selectedModel]!
                )
        } label: {
            Image(systemName: "plus").font(
                .system(size: 40))
        }.padding()

        
        
       

            .disabled(menuClass.buttonDisable)
            .background(menuClass.buttonDisable ? .red.opacity(0.01) : .clear)
            .cornerRadius(10)
    }
}
