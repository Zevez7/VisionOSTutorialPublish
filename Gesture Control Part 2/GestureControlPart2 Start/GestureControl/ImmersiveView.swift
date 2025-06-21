//
//  ImmersiveView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import SwiftUI

struct ImmersiveView: View {

    @State private var currentEntityPosition = SIMD3<Float>(x: 0, y: 1, z: 0)

    @State private var isDragging: Bool = false

    var body: some View {
        RealityView { content in
            let sphereMesh = MeshResource.generateSphere(radius: 0.3)
            let material = SimpleMaterial(color: .red, isMetallic: true)
            let sphereEntity = ModelEntity(
                mesh: sphereMesh,
                materials: [material]
            )

            sphereEntity.position.x = 0.0
            sphereEntity.position.y = 1.0
            sphereEntity.position.z = -1.5

            //            sphereEntity.generateCollisionShapes(recursive: true)

            sphereEntity.components.set(
                CollisionComponent(shapes: [.generateSphere(radius: 0.3)]))

            sphereEntity.components.set(InputTargetComponent())
            sphereEntity.components.set(HoverEffectComponent())
            content.add(sphereEntity)

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
            })
    }
}

#Preview(immersionStyle: .automatic) {
    ImmersiveView()
}
