//
//  LocalCompass.swift
//  HandTrackingPart2
//
//  Created by Dat Nguyen on 1/7/25.
//

import RealityKit
import SwiftUI

class CompassClass {

    static func compassModelEntity(color: UIColor = .clear, scale: Float = 0.7)
        -> ModelEntity
    {

        // sphere
        let meshSphere = MeshResource.generateSphere(radius: 0.1)
        let materialSphere = SimpleMaterial(color: color, isMetallic: false)
        let entitySphere = ModelEntity(
            mesh: meshSphere, materials: [materialSphere])

        // x axis
        let meshX = MeshResource.generateBox(
            width: 0.1, height: 0.005, depth: 0.005)
        let materialX = SimpleMaterial(color: .red, isMetallic: false)
        let entityX = ModelEntity(mesh: meshX, materials: [materialX])
        entityX.transform.translation = SIMD3<Float>(0.05, 0, 0.0)
        entitySphere.addChild(entityX)

        // y axis
        let meshY = MeshResource.generateBox(
            width: 0.005, height: 0.1, depth: 0.005)
        let materialY = SimpleMaterial(color: .green, isMetallic: false)
        let entityY = ModelEntity(mesh: meshY, materials: [materialY])
        entityY.transform.translation = SIMD3<Float>(0.0, 0.05, 0.0)
        entitySphere.addChild(entityY)

        // z axis
        let meshZ = MeshResource.generateBox(
            width: 0.005, height: 0.005, depth: 0.1)
        let materialZ = SimpleMaterial(color: .blue, isMetallic: false)
        let entityZ = ModelEntity(mesh: meshZ, materials: [materialZ])
        entityZ.transform.translation = SIMD3<Float>(0.0, 0.0, 0.05)
        entitySphere.addChild(entityZ)

        let coneHeight: Float = 0.06
        let coneRadius: Float = 0.005
        let coneMesh = MeshResource.generateCone(
            height: coneHeight, radius: coneRadius)

        // x rotation
        let materialRed = SimpleMaterial(color: .red, isMetallic: false)
        let coneEntity = ModelEntity(mesh: coneMesh, materials: [materialRed])

        // Position the cone at the top of the green box and align it for positive X rotation
        coneEntity.transform.translation = SIMD3<Float>(0.0, 0.05, 0.03)  // At the top of the green box
        coneEntity.transform.rotation = simd_quatf(
            angle: .pi / 2, axis: SIMD3<Float>(1, 0, 0))  // Rotate to point along positive X

        entityY.addChild(coneEntity)  // Attach the cone to the green box
        // y rotation
        let materialGreen = SimpleMaterial(color: .green, isMetallic: false)
        let coneEntityYRot = ModelEntity(
            mesh: coneMesh,
            materials: [materialGreen]
        )

        coneEntityYRot.transform.translation = SIMD3<Float>(0.03, 0.0, 0.05)
        coneEntityYRot.transform.rotation = simd_quatf(
            angle: .pi / 2, axis: SIMD3<Float>(0, 0, -1))
        entityZ.addChild(coneEntityYRot)

        // z rotation
        let materialBlue = SimpleMaterial(color: .blue, isMetallic: false)
        let coneEntityZRot = ModelEntity(
            mesh: coneMesh, materials: [materialBlue])
        coneEntityZRot.transform.translation = SIMD3<Float>(0.05, 0.03, 0.0)  
        coneEntityZRot.transform.rotation = simd_quatf(
            angle: .pi / 2, axis: SIMD3<Float>(0, 1, 0))  // Rotate to point along positive Z
        entityX.addChild(coneEntityZRot)

        entitySphere.scale = SIMD3<Float>(scale, scale, scale)
        return entitySphere
    }

}
