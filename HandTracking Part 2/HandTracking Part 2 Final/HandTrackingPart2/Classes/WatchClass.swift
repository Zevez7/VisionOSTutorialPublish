//
//  WatchClass.swift
//  HandTrackingPart2
//
//  Created by Dat Nguyen on 1/14/25.
//

import RealityKit
import SwiftUI

struct ColorComponent: Component {
    var color: UIColor
}

class WatchClass {

    static func loadWatchModelEntity(scale: Float = 1.0) async -> ModelEntity? {
        if let loadwatch = try? await ModelEntity(named: "Hand_watch.usdz") {
            print("loaded watch model")
            await loadwatch.setScale(
                SIMD3<Float>(scale, scale, scale), relativeTo: nil
            )

            return loadwatch
        } else {
            print("unable to load model")
            return nil
        }

    }

    static func ChangeWatchBeltColor(watchEntity: ModelEntity, color: UIColor) {
        var swapMaterial = PhysicallyBasedMaterial()
        swapMaterial.baseColor.tint = color
        swapMaterial.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(
            color: color)
        swapMaterial.emissiveIntensity = 1

        if var materialsArray = watchEntity.model?.materials {
            materialsArray[2] = swapMaterial
            watchEntity.model?.materials = materialsArray
        }
        
        if watchEntity.components.has(ColorComponent.self) {
            watchEntity.components.set(ColorComponent(color: color))
        }

    }

    static func selectableWatchModelEntity(
        x: Float = 0.0,
        y: Float = 1.0,
        z: Float = -1.0,
        scale: Float = 0.2
    ) async -> ModelEntity? {
        if let watchEntity = await loadWatchModelEntity(scale: scale) {
            await watchEntity.setPosition(
                SIMD3<Float>(x: x, y: y, z: z), relativeTo: nil)
            await watchEntity.components.set(InputTargetComponent())
            await watchEntity.generateCollisionShapes(recursive: true)
            await watchEntity.components.set(HoverEffectComponent())
            await watchEntity.components.set(ColorComponent(color: .white))
            return watchEntity
        }
        return nil
    }

}
