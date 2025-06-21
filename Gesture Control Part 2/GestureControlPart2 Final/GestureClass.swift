//
//  GestureClass.swift
//  GestureControl
//
//  Created by Dat Nguyen on 1/23/25.
//

import RealityKit
import SwiftUI

class GestureClass {

    func createSphereEntity(
        color: UIColor = .white, x: Float = 0.0, y: Float = 1.0, z: Float = -1.0
    ) -> ModelEntity {

        let sphereMesh = MeshResource.generateSphere(radius: 0.1)
        let material = SimpleMaterial(color: color, isMetallic: true)
        let sphereEntity = ModelEntity(
            mesh: sphereMesh,
            materials: [material]
        )

        sphereEntity.setPosition(
            SIMD3<Float>(x: x, y: y, z: z), relativeTo: nil)

        sphereEntity.components.set(
            CollisionComponent(shapes: [.generateSphere(radius: 0.3)]))

        sphereEntity.components.set(InputTargetComponent())
        sphereEntity.components.set(HoverEffectComponent())

        return sphereEntity

    }
    
    func createRectangleEntity(
        color: UIColor = .white, x: Float = 0.0, y: Float = 1.0, z: Float = -1.0
    ) -> ModelEntity {

        let Mesh = MeshResource.generateBox( width: 0.1, height: 0.2, depth: 0.1 )
        let material = SimpleMaterial(color: color, isMetallic: true)
        let Entity = ModelEntity(
            mesh: Mesh,
            materials: [material]
        )

        Entity.setPosition(
            SIMD3<Float>(x: x, y: y, z: z), relativeTo: nil)

        Entity.components.set(
            CollisionComponent(shapes: [.generateBox( width: 0.1, height: 0.2, depth: 0.1)]))

        Entity.components.set(InputTargetComponent())
        Entity.components.set(HoverEffectComponent())

        return Entity

    }

}
