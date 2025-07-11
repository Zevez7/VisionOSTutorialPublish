//
//  HandClass.swift
//  HandTrackingPart1
//
//  Created by Dat Nguyen on 12/8/24.
//

import ARKit
import RealityKit
import SwiftUI

@MainActor @Observable
class HandClass {

    let session = ARKitSession()

    let handTracking = HandTrackingProvider()

    let RootEntity = Entity()
    var WatchModelEntity: ModelEntity?

//    var LeftHandAnchorEntity: ModelEntity?
    var LeftHandForearmEntity: [HandSkeleton.JointName: ModelEntity] = [:]
//    var LeftFingerTipsEntity: [HandSkeleton.JointName: ModelEntity] = [:]

    var RightHandAnchorEntity: ModelEntity?
    var RightFingerTipsEntity: [HandSkeleton.JointName: ModelEntity] = [:]
    
    func setupWatchEntity(watchModel:ModelEntity){
        
        WatchModelEntity = watchModel
        
//        WatchModelEntity?.addChild(CompassClass.compassModelEntity(scale: 3))
        WatchModelEntity?.transform.rotation *= simd_quatf (angle: -.pi/2, axis: [0,0,1])
        WatchModelEntity?.transform.rotation *= simd_quatf (angle: .pi/2, axis: [1,0,0])
        
        WatchModelEntity?.transform.translation = [0.0,-0.015,0.0]
            
        LeftHandForearmEntity[.forearmWrist]?.addChild(WatchModelEntity!)
    
//        LeftHandForearmEntity[.forearmWrist]?
//            .addChild(CompassClass.compassModelEntity())
        
       }
    
    func setupEntity() {

        LeftHandForearmEntity = [
            .forearmArm: createSphereEntity(
                name: "ForearmArm",
                color: .green,
                radius: 0.03
            ),
            .forearmWrist: createSquareEntity(
                name:"ForearmWrist",
                color: .clear,
                width: 0.05,
                height: 0.03,
                depth: 0.05
            )
        ]
        
        RootEntity.addChild(LeftHandForearmEntity[.forearmArm]!)
        RootEntity.addChild(LeftHandForearmEntity[.forearmWrist]!)
        
//        LeftHandAnchorEntity = createSphereEntity(
//            name: "LeftHandAnchorEntity",
//            color: .blue,
//            radius: 0.03,
//            x: -0.3
//        )
//
//        RootEntity.addChild(LeftHandAnchorEntity!)
        
        RightHandAnchorEntity = createSphereEntity(
            name: "RightHandAnchorEntity",
            color: .blue,
            radius: 0.03,
            x: -0.3
        )

        RootEntity.addChild(RightHandAnchorEntity!)

//        LeftFingerTipsEntity[.thumbTip] = createSphereEntity(
//            name: "thumbTip", x: -0.2)
//        LeftFingerTipsEntity[.indexFingerTip] = createSphereEntity(
//            name: "indexFingerTip", x: -0.1)
//        LeftFingerTipsEntity[.middleFingerTip] = createSphereEntity(
//            name: "middleFingerTip", x: 0.0)
//        LeftFingerTipsEntity[.ringFingerTip] = createSphereEntity(
//            name: "ringFingerTip", x: 0.1)
//        LeftFingerTipsEntity[.littleFingerTip] = createSphereEntity(
//            name: "littleFingerTip", x: 0.2)
//
//        for value in LeftFingerTipsEntity.values {
//            RootEntity.addChild(value)
//        }
        
        RightFingerTipsEntity[.thumbTip] = createSphereEntity(
            name: "thumbTip", x: -0.2)
        RightFingerTipsEntity[.indexFingerTip] = createSphereEntity(
            name: "indexFingerTip", x: -0.1)
        RightFingerTipsEntity[.middleFingerTip] = createSphereEntity(
            name: "middleFingerTip", x: 0.0)
        RightFingerTipsEntity[.ringFingerTip] = createSphereEntity(
            name: "ringFingerTip", x: 0.1)
        RightFingerTipsEntity[.littleFingerTip] = createSphereEntity(
            name: "littleFingerTip", x: 0.2)

        for value in RightFingerTipsEntity.values {
            RootEntity.addChild(value)
        }
        
    }

    func createSphereEntity(
        name: String = "",
        color: UIColor = .yellow,
        radius: Float = 0.01,
        x: Float = 0.0,
        y: Float = 1.5,
        z: Float = -1.0

    ) -> ModelEntity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.setPosition(SIMD3<Float>(x, y, z), relativeTo: nil)
        entity.name = name

        return entity
    }
    
    func createSquareEntity(
        name: String = "",
        color: UIColor = .white,
        width: Float = 0.01,
        height: Float = 0.01,
        depth: Float = 0.1,
        x: Float = 0.0,
        y: Float = 1.3,
        z: Float = -1.0

    ) -> ModelEntity {
        let mesh = MeshResource.generateBox(size: [width, height, depth])
        let material = SimpleMaterial(color: color, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.setPosition(SIMD3<Float>(x, y, z), relativeTo: nil)
        entity.name = name

        return entity
    }

    func checkHandTracking() -> Bool {
        return HandTrackingProvider.isSupported
            && handTracking.state == .initialized
    }

    func continuousHandUpdate() async {

        for await update in handTracking.anchorUpdates {

            let handAnchor = update.anchor
            guard handAnchor.isTracked else { continue }

            let handAnchorTransform = handAnchor.originFromAnchorTransform

            guard
                // forearm
                let forearmArmJointTransform = handAnchor.handSkeleton?.joint(
                    .forearmArm
                ).anchorFromJointTransform,
                
                let forearmWristJointTransform = handAnchor.handSkeleton?.joint(
                        .forearmWrist
                    ).anchorFromJointTransform,
                
                // fingertip
                let thumbTipJointTransform = handAnchor.handSkeleton?.joint(
                    .thumbTip
                ).anchorFromJointTransform,
                let indexFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(.indexFingerTip).anchorFromJointTransform,
                let middleFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(.middleFingerTip).anchorFromJointTransform,
                let ringFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(.ringFingerTip).anchorFromJointTransform,
                let littleFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(.littleFingerTip).anchorFromJointTransform
            else { continue }
            // forearm
            let forearmArmWorldTransform =
            handAnchorTransform * forearmArmJointTransform
            let forearmWristWorldTransform =
            handAnchorTransform * forearmWristJointTransform
                      
            // fingertip
            let thumbTipWorldTransform =
                handAnchorTransform * thumbTipJointTransform
            let indexFingerTipWorldTransform =
                handAnchorTransform * indexFingerTipJointTransform
            let middleFingerTipWorldTransform =
                handAnchorTransform * middleFingerTipJointTransform
            let ringFingerTipWorldTransform =
                handAnchorTransform * ringFingerTipJointTransform
            let littleFingerTipWorldTransform =
                handAnchorTransform * littleFingerTipJointTransform

            if handAnchor.chirality == .left {
                //forearm
                LeftHandForearmEntity[.forearmArm]?
                    .setTransformMatrix(forearmArmWorldTransform, relativeTo: nil)
                LeftHandForearmEntity[.forearmWrist]?
                    .setTransformMatrix(forearmWristWorldTransform, relativeTo: nil)
                
//                WatchModelEntity?.setTransformMatrix(forearmWristWorldTransform, relativeTo: nil)
                
                WatchModelEntity?.setScale(SIMD3<Float>(0.15, 0.15, 0.15), relativeTo: nil)
                
                //fingertip
//                LeftHandAnchorEntity?
//                    .setTransformMatrix(handAnchorTransform, relativeTo: nil)
//                LeftFingerTipsEntity[.thumbTip]?
//                    .setTransformMatrix(thumbTipWorldTransform, relativeTo: nil)
//                LeftFingerTipsEntity[.indexFingerTip]?
//                    .setTransformMatrix(
//                        indexFingerTipWorldTransform, relativeTo: nil)
//                LeftFingerTipsEntity[.middleFingerTip]?
//                    .setTransformMatrix(
//                        middleFingerTipWorldTransform, relativeTo: nil)
//                LeftFingerTipsEntity[.ringFingerTip]?
//                    .setTransformMatrix(
//                        ringFingerTipWorldTransform,
//                        relativeTo: nil)
//                LeftFingerTipsEntity[.littleFingerTip]?
//                    .setTransformMatrix(
//                        littleFingerTipWorldTransform, relativeTo: nil)
            } else {
                RightHandAnchorEntity?
                    .setTransformMatrix(handAnchorTransform, relativeTo: nil)
                RightFingerTipsEntity[.thumbTip]?
                    .setTransformMatrix(thumbTipWorldTransform, relativeTo: nil)
                RightFingerTipsEntity[.indexFingerTip]?
                    .setTransformMatrix(
                        indexFingerTipWorldTransform, relativeTo: nil)
                RightFingerTipsEntity[.middleFingerTip]?
                    .setTransformMatrix(
                        middleFingerTipWorldTransform, relativeTo: nil)
                RightFingerTipsEntity[.ringFingerTip]?
                    .setTransformMatrix(
                        ringFingerTipWorldTransform,
                        relativeTo: nil)
                RightFingerTipsEntity[.littleFingerTip]?
                    .setTransformMatrix(
                        littleFingerTipWorldTransform, relativeTo: nil)
            }

        }

    }

}
