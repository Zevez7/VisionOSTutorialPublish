//
//  ImmersiveView.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 2/3/25.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    @Environment(ARClass.self) var arClass

    var body: some View {
        RealityView { content in
            let rootEntity = arClass.rootEntity
            content.add(rootEntity)
        }.task {
            do {
                if arClass.checkSceneReconstruction() {
                    print("Scene Reconstruction PASSED")
                    try await arClass.ARsession.run([
                        arClass.sceneReconstruction
                    ])
                } else {
                    print("Scene Reconstruction FAILED")
                }
            } catch { print("Unable to start Scene Reconstruction: \(error)") }
        }.task {
            await arClass.runSceneConstruction()
        }.gesture(
            SpatialTapGesture().targetedToAnyEntity().onEnded { value in
                let location3D = value.convert(
                    value.location3D, from: .local, to: .scene)
                arClass.addCube(tapLocation: location3D, color: .white)
            }
        )
    }

}

#Preview(immersionStyle: .automatic) {
    ImmersiveView().environment(ARClass())
}
