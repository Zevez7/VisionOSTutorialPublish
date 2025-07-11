//
//  HandView.swift
//  HandTrackingPart1
//
//  Created by Dat Nguyen on 12/8/24.
//

import RealityKit
import SwiftUI

struct HandView: View {
    @State var handClass = HandClass()
    @State var watchClass = WatchClass.self

    var body: some View {
        RealityView { content in
            let rootEntity = handClass.RootEntity

            handClass.setupEntity()

            if let watchModel = await watchClass.loadWatchModelEntity(
                scale: 0.15)
            {
                handClass.setupWatchEntity(watchModel: watchModel)

                watchClass
                    .ChangeWatchBeltColor(
                        watchEntity: watchModel, color: .black)

            }

            let watchColors: [UIColor] = [
                .red, .blue, .yellow, .green, .orange, .yellow, .purple, .cyan,
                .brown,
            ]

            var xVal: Float = -0.5

            for color in watchColors {

                if let watchModelEntity =
                    await watchClass.selectableWatchModelEntity(
                        x: xVal, scale: 0.3)
                {
                    xVal += 0.25
                    watchClass
                        .ChangeWatchBeltColor(
                            watchEntity: watchModelEntity,
                            color: color
                        )
                    rootEntity.addChild(watchModelEntity)
                }

            }

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
        }.gesture(
            TapGesture()
                .targetedToEntity(where: .has(ColorComponent.self))
                .onEnded { value in
                    if let colorComponent = value.entity.components[
                        ColorComponent.self],
                        let handWatchEntity = handClass.WatchModelEntity
                    {
                        watchClass
                            .ChangeWatchBeltColor(
                                watchEntity: handWatchEntity,
                                color: colorComponent.color
                            )
                    }
                }
        )
    }
}

#Preview(immersionStyle: .automatic) {
    HandView()
}
