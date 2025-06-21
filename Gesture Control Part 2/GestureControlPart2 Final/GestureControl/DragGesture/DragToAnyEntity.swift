//
//  ImmersiveView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import SwiftUI

struct DragToAnyEntity: View {

    @State private var currentEntityPosition = SIMD3<Float>(x: 0, y: 1, z: 0)

    @State private var isDragging: Bool = false

    var gestureClass = GestureClass()
    
    var body: some View {
        RealityView { content in
            
            let sphereEntity1 = gestureClass.createSphereEntity(color:.blue,x:0.0)
            let sphereEntity2 = gestureClass.createSphereEntity(color: .red, x:0.3)
            let sphereEntity3 = gestureClass.createSphereEntity(color: .yellow, x:0.6)
      
            content.add(sphereEntity1)
            content.add(sphereEntity2)
            content.add(sphereEntity3)

        }.gesture(
            DragGesture().targetedToAnyEntity().onChanged { value in

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
            }
        )
    }
}

#Preview(immersionStyle: .automatic) {
    DragToAnyEntity()
}
