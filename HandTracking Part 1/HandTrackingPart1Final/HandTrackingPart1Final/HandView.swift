//
//  Untitled.swift
//  HandTrackingPart1Start
//
//  Created by Dat Nguyen on 12/7/24.
//

import RealityKit
import SwiftUI

struct HandView: View {
    @State var handClass = HandClass()

    var body: some View {
        RealityView { content in
            let rootEntity = handClass.RootEntity

            handClass.setupEntity()
            content.add(rootEntity)

        }.task {
            do {
                let checkHandTracking = handClass.checkHandTracking()
                if checkHandTracking {
                    print("HandTracking passed", checkHandTracking)
                    try await handClass.session.run([handClass.handTracking])
                } else {
                    print("HandTracking failed")
                }
            } catch {
                print("Unable to start session", error)
            }
        }.task {
            await handClass.continuousHandUpdate()
        }
    }
}

//#Preview(immersionStyle: .automatic) {
//    HandView()
//}
