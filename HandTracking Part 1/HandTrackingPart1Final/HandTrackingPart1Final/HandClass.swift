//
//  HandClass.swift
//  HandTrackingPart1Start
//
//  Created by Dat Nguyen on 12/7/24.
//

import ARKit
import RealityKit
import SwiftUI

@MainActor @Observable
class HandClass {
    //    HandSkeleton.JointName.

    let session = ARKitSession()
    let handTracking = HandTrackingProvider()

    let RootEntity = Entity()

    var LeftHandAnchorEntity: ModelEntity?

    var LeftFingerTipsEntity: [HandSkeleton.JointName: ModelEntity] = [:]

    var RightHandAnchorEntity: ModelEntity?

    var RightFingerTipsEntity: [HandSkeleton.JointName: ModelEntity] = [:]

    func setupEntity() {

        LeftHandAnchorEntity = createSphereEntity(
            name: "LeftHandAnchorEntity", color: .blue, radius: 0.03, x: -0.3)

        RootEntity.addChild(LeftHandAnchorEntity!)

        LeftFingerTipsEntity[.thumbTip] = createSphereEntity(
            name: "thumbTip", x: -0.2)
        LeftFingerTipsEntity[.indexFingerTip] = createSphereEntity(
            name: "indexFingerTip", x: -0.1)
        LeftFingerTipsEntity[.middleFingerTip] = createSphereEntity(
            name: "middleFingerTip", x: 0)
        LeftFingerTipsEntity[.ringFingerTip] = createSphereEntity(
            name: "ringFingerTip", x: 0.1)
        LeftFingerTipsEntity[.littleFingerTip] = createSphereEntity(
            name: "littleFingerTip", x: 0.2)

        for value in LeftFingerTipsEntity.values {
            RootEntity.addChild(value)
        }

        RightHandAnchorEntity = createSphereEntity(
            name: "RightHandAnchorEntity", color: .blue, radius: 0.03, x: -0.3)

        RootEntity.addChild(RightHandAnchorEntity!)

        RightFingerTipsEntity[.thumbTip] = createSphereEntity(
            name: "thumbTip", x: -0.2)
        RightFingerTipsEntity[.indexFingerTip] = createSphereEntity(
            name: "indexFingerTip", x: -0.1)
        RightFingerTipsEntity[.middleFingerTip] = createSphereEntity(
            name: "middleFingerTip", x: 0)
        RightFingerTipsEntity[.ringFingerTip] = createSphereEntity(
            name: "ringFingerTip", x: 0.1)
        RightFingerTipsEntity[.littleFingerTip] = createSphereEntity(
            name: "littleFingerTip", x: 0.2)

        for value in RightFingerTipsEntity.values {
            RootEntity.addChild(value)
        }
    }

    func createSphereEntity(
        name: String = "", color: UIColor = .yellow, radius: Float = 0.01,
        x: Float = 0.0, y: Float = 1.5,
        z: Float = -1.0
    ) -> ModelEntity {

        let mesh = MeshResource.generateSphere(radius: radius)
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
//             print("updates", update)
            // updates AnchorUpdate(
            // event: updated,
            // timestamp: 101678.95088087447,
            // anchor: HandAnchor(
            // chirality: right,
            // id: F247E7DA-36F6-4DCD-B416-06E921A9CAAB,
            // isTracked: false,
            // originFromAnchorTransform: <translation=(-0.415375 1.410358 -0.660614) rotation=(-24.87° 82.53° -0.67°)>,
            // handSkeleton: HandSkeleton(jointCount: 27)))

            let handAnchor = update.anchor

            guard handAnchor.isTracked else { continue }

            let handAnchorTransform = handAnchor.originFromAnchorTransform

            guard
                let thumbTipJointTransform = handAnchor.handSkeleton?.joint(
                    .thumbTip
                ).anchorFromJointTransform,
                let indexFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(
                        .indexFingerTip
                    ).anchorFromJointTransform,
                let middleFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(
                        .middleFingerTip
                    ).anchorFromJointTransform,
                let ringFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(
                        .ringFingerTip
                    ).anchorFromJointTransform,
                let littleFingerTipJointTransform = handAnchor.handSkeleton?
                    .joint(
                        .littleFingerTip
                    ).anchorFromJointTransform
            else { continue }

            //            print(thumbTipJoint)

            // name: thumbTip,
            // isTracked: true,
            // parentFromJointTransform: <translation=(0.030629 0.000421 -0.004303) rotation=(0.00° -0.00° 0.00°)>,
            // anchorFromJointTransform: <translation=(0.112858 0.081560 -0.017999) rotation=(57.46° 94.47° 98.95°)>)

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

                LeftHandAnchorEntity?.setTransformMatrix(
                    handAnchorTransform, relativeTo: nil)

                LeftFingerTipsEntity[.thumbTip]?
                    .setTransformMatrix(thumbTipWorldTransform, relativeTo: nil)
                LeftFingerTipsEntity[.indexFingerTip]?
                    .setTransformMatrix(
                        indexFingerTipWorldTransform, relativeTo: nil)
                LeftFingerTipsEntity[.middleFingerTip]?
                    .setTransformMatrix(
                        middleFingerTipWorldTransform, relativeTo: nil)
                LeftFingerTipsEntity[.ringFingerTip]?
                    .setTransformMatrix(
                        ringFingerTipWorldTransform,
                        relativeTo: nil)
                LeftFingerTipsEntity[.littleFingerTip]?
                    .setTransformMatrix(
                        littleFingerTipWorldTransform,
                        relativeTo: nil
                    )
            } else {
                RightHandAnchorEntity?.setTransformMatrix(
                    handAnchorTransform, relativeTo: nil)

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
                        littleFingerTipWorldTransform,
                        relativeTo: nil
                    )
            }
        }

    }
}
