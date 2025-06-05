//
//  ARClass.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/3/25.
//

import ARKit
import RealityKit
import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class ARClass: ObservableObject {
    var rootEntity: Entity = Entity()

    var surfaceAnchors: [UUID: ModelEntity] = [:]

    let ARsession = ARKitSession()
    let sceneReconstruction = SceneReconstructionProvider()

    func checkSceneReconstruction() -> Bool {
        return SceneReconstructionProvider.isSupported

    }

    func addPhysicsInput(
        entity: ModelEntity, shape: ShapeResource,
        mode: PhysicsBodyMode = .static
    ) {

        entity.components.set(CollisionComponent(shapes: [shape]))
        entity.components.set(InputTargetComponent())
        entity.components.set(PhysicsBodyComponent(mode: mode))
    }

    func runSceneConstruction() async {

        let colorSelection: [UIColor] = [
            .blue,
            .red,
            .green,
            .yellow,
            .purple,
            .orange,
            .brown,
            .magenta,
            .gray,
        ]

        for await update in sceneReconstruction.anchorUpdates {
            let updateAnchor = update.anchor

            guard
                let shape = try? await ShapeResource.generateStaticMesh(
                    from: updateAnchor)
            else { continue }

            switch update.event {

            case .added:

//                let material = SimpleMaterial(
//                    color: colorSelection.randomElement()!.withAlphaComponent(
//                        0.5), isMetallic: false
//                )
                
                
//                guard let mesh = try? await MeshResource(from: updateAnchor)
//                else { return }

//                let modelEntity = ModelEntity(mesh: mesh, materials: [material])
                let modelEntity = ModelEntity()

                modelEntity
                    .setTransformMatrix(
                        update.anchor.originFromAnchorTransform,
                        relativeTo: nil
                    )
                surfaceAnchors[updateAnchor.id] = modelEntity
                rootEntity.addChild(modelEntity)
                addPhysicsInput(entity: modelEntity, shape: shape)

            case .updated:
                guard let modelEntity = surfaceAnchors[updateAnchor.id] else {
                    continue
                }

//                let material = modelEntity.model?.materials ?? []
//
//                guard let mesh = try? await MeshResource(from: updateAnchor)
//                else { return }

//                modelEntity.components.set(
//                    ModelComponent(mesh: mesh, materials: material))
                
                modelEntity.collision?.shapes = [shape]

                modelEntity.transform = Transform(
                    matrix: updateAnchor.originFromAnchorTransform)

            case .removed:
                surfaceAnchors[updateAnchor.id]?.removeFromParent()

                // Remove the anchor entry from the collection.
                surfaceAnchors[updateAnchor.id] = nil
            }
        }
    }

    func addCube(tapLocation: SIMD3<Float>, color: UIColor) {

        let mesh = MeshResource.generateBox(size: 0.1)
        let material = SimpleMaterial(color: color, isMetallic: true)

        let entity = ModelEntity(
            mesh: mesh,
            materials: [material]
        )
        let placementLocation = tapLocation + SIMD3<Float>(0, 0.3, 0)
        entity.setPosition(placementLocation, relativeTo: nil)
        
        // Define a collision shape manually
        
        let collisionShape = ShapeResource.generateBox(size: [0.1, 0.1, 0.1])

        addPhysicsInput(entity: entity, shape: collisionShape, mode: .dynamic)

        rootEntity.addChild(entity)

    }
}
