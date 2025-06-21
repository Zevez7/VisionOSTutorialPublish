//
//  ImmersiveView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import SwiftUI

struct Interaction: Component {}

struct DragToEntityPredicate: View {

    @State private var currentEntityPosition = SIMD3<Float>(x: 0, y: 1, z: 0)

    @State private var isDragging: Bool = false

    var gestureClass: GestureClass
    
    let sphereEntity1:ModelEntity
    let sphereEntity2:ModelEntity
    let sphereEntity3:ModelEntity
    
    init(){
        self.gestureClass = GestureClass()
        self.sphereEntity1 = gestureClass
            .createSphereEntity(color:.orange, x:0.0)
        
        self.sphereEntity2 = gestureClass
            .createSphereEntity(color:.systemTeal, x:0.3)
        self.sphereEntity3 = gestureClass
            .createSphereEntity(color:.systemPink, x:0.6)
    }
    
    var body: some View {
        RealityView { content in
            
            sphereEntity1.components.set(Interaction())
            sphereEntity3.components.set(Interaction())
      
            content.add(sphereEntity1)
            content.add(sphereEntity2)
            content.add(sphereEntity3)

        }.gesture(
            DragGesture().targetedToEntity(where:.has(Interaction.self)).onChanged { value in

                if isDragging == false {
                    currentEntityPosition = value.entity.position
                    isDragging = true
                }

                let gestureTranslation = value.convert(
                    value.gestureValue.translation3D, from: .local, to: .scene)

                value.entity.position =
                    currentEntityPosition
                    + gestureTranslation

            }.onEnded { value in
                isDragging = false
            })
    }
}

#Preview(immersionStyle: .automatic) {
    DragToEntityPredicate()
}
