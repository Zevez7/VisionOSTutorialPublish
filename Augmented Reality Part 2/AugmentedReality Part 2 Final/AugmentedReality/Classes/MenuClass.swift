//
//  MenuClass.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 1/29/25.
//


import SwiftUI
import RealityKit

@MainActor
@Observable
class MenuClass: ObservableObject {
    
    var rootEntity: Entity = Entity()
    
    var modelStore: [String: ModelEntity] = [:]
    
    var selectedModel: String = "MODEL"

    
    var buttonDisable: Bool = false
    
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
    
    func rotate(entity: Entity,yrotation: Float = 1) {
          let angle: Float = .pi / 8 // Rotate 22.5 degrees each button press
          let rotation = simd_quatf(angle: angle, axis: [0, yrotation, 0]) // Rotate around Y-axis
          entity.transform.rotation *= rotation
      }
    
    func scale(entity: Entity, magnitude: Float = 1.1, isScalingUp: Bool = true) {
        var transform = entity.transform
        let scaleFactor = isScalingUp ? magnitude : 1 / magnitude
        transform.scale *= SIMD3<Float>(repeating: scaleFactor)
        entity.transform = transform  // Apply the new transform
    }
    
}
