//
//  ARClass.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 1/28/25.
//

import ARKit
import RealityKit
import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class ARClass: ObservableObject {
    var rootEntity: Entity = Entity()

    var modelStore: [String: ModelEntity] = [:]
    
    var surfaceAnchors: [UUID: ModelEntity] = [:]
    

    let ARsession = ARKitSession()
    let sceneReconstruction = SceneReconstructionProvider()


    func checkSceneReconstruction() -> Bool {
        return SceneReconstructionProvider.isSupported
    }

    func addPhysicsInput(entity: ModelEntity, shape: ShapeResource) {

        entity.components.set(
            CollisionComponent(
                shapes: [shape], isStatic: true))
        entity.components.set(InputTargetComponent())
        entity.components.set(PhysicsBodyComponent(mode: .static))
    }

    func loadModelEntity(name: String, position: SIMD3<Float> = SIMD3<Float>(0,0,0)) async {
        // Try to load the model asynchronously
        if let loadModel = try? await ModelEntity(
            named: name)
        {
            print("Load model entity successfully: \(name)")
            loadModel.setPosition(position, relativeTo: nil)
            modelStore[name] = loadModel
            rootEntity.addChild(loadModel)

        } else {
            print("Unable to load model: \(name)")
        }
    }
    
    @MainActor
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
//                    color:
//                        colorSelection
//                        .randomElement()!
//                        .withAlphaComponent(0.05),
//                    isMetallic: false)
//
//                guard let mesh = try? await MeshResource(from: update.anchor)
//                else { return }
//
//                let modelEntity = ModelEntity(mesh: mesh, materials: [material])

                let modelEntity = ModelEntity()
                
                modelEntity.setTransformMatrix(
                    update.anchor.originFromAnchorTransform,
                    relativeTo: nil
                )

                surfaceAnchors[updateAnchor.id] = modelEntity
                rootEntity.addChild(modelEntity)

                addPhysicsInput(entity: modelEntity, shape: shape)

            case .updated:
                guard let modelEntity = surfaceAnchors[updateAnchor.id] else {continue}

                let material = modelEntity.model?.materials ?? []

                guard let mesh = try? await MeshResource(from: update.anchor)
                else { return }

                modelEntity.components.set(
                    ModelComponent(mesh: mesh, materials: material))

                modelEntity.transform = Transform(
                    matrix: updateAnchor.originFromAnchorTransform)

                modelEntity.collision?.shapes = [shape]

            case .removed:
                surfaceAnchors[updateAnchor.id]?.removeFromParent()

                // Remove the anchor entry from the collection.
                surfaceAnchors[updateAnchor.id] = nil

            }

        }
    }
    
    func addCube(tapLocation: SIMD3<Float>, color: UIColor = .green, mode: PhysicsBodyMode = .dynamic) {
        let placementLocation = tapLocation + SIMD3<Float>(0, 0.5, 0)
        print("tap", tapLocation)
        print("placementLocation", placementLocation)
        
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.1),
            materials: [SimpleMaterial(color: color, isMetallic: true)]
        )
        
        
        entity.setPosition(placementLocation, relativeTo: nil)
        entity.components.set(InputTargetComponent())

        // Define a collision shape manually
        let collisionShape = ShapeResource.generateBox(size: [0.1, 0.1, 0.1])
        entity.components.set(CollisionComponent(shapes: [collisionShape]))

//        entity.generateCollisionShapes(recursive: false)

        
        let physicsMaterial = PhysicsMaterialResource.generate(
            friction: 0.5, restitution: 0.3)
        
        entity.components.set(
            PhysicsBodyComponent(
                shapes: [collisionShape],  // Use the same collision shape
                mass: 1.0,
                material: physicsMaterial,
                mode: mode
            )
        )

        rootEntity.addChild(entity)
        
    }
    
    
    func addTable( x:Float,y:Float,z:Float,size:Float = 0.1,depth:Float = 0.1 , color: UIColor = .red) {
        
        let mesh = MeshResource.generateBox(size:[size,depth,size])
        let materials = [SimpleMaterial(color: color, isMetallic: false)]
        
        let TableEntity = ModelEntity(mesh: mesh, materials: materials)
        
        
        TableEntity.generateCollisionShapes(recursive: false)
        
        TableEntity.setPosition(SIMD3 <Float>(x,y,z), relativeTo: nil)
        
        
        TableEntity.components.set(InputTargetComponent())
        TableEntity.components.set(HoverEffectComponent())
        TableEntity.physicsBody = PhysicsBodyComponent(mode: .static)
        rootEntity.addChild(TableEntity)
        
    }
    }
