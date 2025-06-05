//
//  ImmersiveView.swift
//  AugmentedReality
//
//  Created by Dat Nguyen on 1/28/25.
//

import ARKit
import RealityKit
import SwiftUI

struct ImmersiveView: View {
    @Environment(ARClass.self) var arClass
    @Environment(MenuClass.self) var menuClass

    var body: some View {
        RealityView { content in
            let rootEntity = arClass.rootEntity

            content.add(rootEntity)

            //            arClass
            //                .addCube(
            //                    tapLocation: SIMD3<Float>(0, 0.6, -1.0),
            //                    color: .blue,
            //                    mode: .static
            //                )
            //            arClass.addCube(tapLocation: SIMD3<Float>(0, 0.6, -1.2), color: .blue,mode:.static)

            arClass.addTable(
                x: 0.4, y: 1, z: -1.1, size: 0.3, depth: 0.01, color: .red)

            arClass
                .addTable(
                    x: 0.8,
                    y: 0.8,
                    z: -1.1,
                    size: 0.6,
                    color: .blue
                )

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
            } catch {
                print("Unable to start Scene Reconstruction: \(error)")
            }

        }.task {
            await arClass.runSceneConstruction()
        }.gesture(
            SpatialTapGesture().targetedToAnyEntity().onEnded { value in
                let location3D = value.convert(
                    value.location3D, from: .local, to: .scene)
                //                arClass.addCube(tapLocation: location3D)

                if menuClass.selectedModel != "MODEL" {

                    if let model =
                        arClass
                        .modelStore[menuClass.selectedModel]
                    {
                        model.setPosition(
                            location3D, relativeTo: nil
                        )

                    }

                }

            })

    }
}

#Preview(immersionStyle: .automatic) {
    ImmersiveView()
        .environment(ARClass()).environment(MenuClass())

}
