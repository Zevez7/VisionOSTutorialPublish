//
//  ButtonView.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/2/25.
//

import SwiftUI
import ARKit

struct ButtonView: View {
    
    var title: String
    var name: String
    var arScale: Float = 1.0
    var menuScale: Float = 1.0
    
    @Environment(ARClass.self) var arClass
    @Environment(MenuClass.self) var menuClass

    var body: some View {
        Button {
            menuClass.selectedModel = name
            menuClass.rootEntity.children.removeAll()

            if name == "MODEL" {
                return
            }


            if menuClass.modelStore.keys.contains(name) {
                menuClass.rootEntity.addChild(menuClass.modelStore[name]!)
            } else {
                Task {
                    menuClass.buttonDisable = true
        
                    
                    await menuClass.loadModelEntity(name: name, position: SIMD3<Float>(0, -0.1, 0))
                    menuClass.modelStore[name]?.setScale(SIMD3<Float>(menuScale, menuScale, menuScale), relativeTo: nil)
                    
                    
                    await arClass.loadModelEntity(name: name,position: SIMD3<Float>(1, 1.2, -1.75))
                    arClass.modelStore[name]?.setScale(SIMD3<Float>(arScale, arScale, arScale), relativeTo: nil)
                    
                    menuClass.buttonDisable = false
                }            }
        } label: {
            Text(title)
                .frame(width: 400)
                .padding(10)
                .foregroundColor(.white)
        }.disabled(menuClass.buttonDisable)
            .background(menuClass.buttonDisable ? .red.opacity(0.01) : .clear)
            .cornerRadius(10)
    }
}
