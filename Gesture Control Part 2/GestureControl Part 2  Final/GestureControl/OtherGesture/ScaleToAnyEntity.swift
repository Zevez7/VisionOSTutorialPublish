//
//  ImmersiveView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import SwiftUI

struct ScaleToAnyEntity: View {

    @State private var currentScale:  SIMD3<Float> = SIMD3<Float>(0,0,0)

    @State private var isGesturing: Bool = false

    var gestureClass = GestureClass()
    
    var body: some View {
        RealityView { content in
            
            let rectangleEntity1 = gestureClass.createRectangleEntity(color:.blue,x:0.0)
            rectangleEntity1.name = "blue"
            let rectangleEntity2 = gestureClass.createRectangleEntity(color: .red, x:0.3)
            rectangleEntity2.name = "red"
            let rectangleEntity3 = gestureClass.createRectangleEntity(color: .yellow, x:0.6)
            rectangleEntity3.name = "yellow"
      
            content.add(rectangleEntity1)
            content.add(rectangleEntity2)
            content.add(rectangleEntity3)

        }.gesture(
            MagnifyGesture().targetedToAnyEntity().onChanged { value in

                if isGesturing == false {
                    currentScale = value.entity.transform.scale
                    isGesturing = true
                }

                let updateGestureScale = Float(value.gestureValue.magnification)

                value.entity.scale = currentScale * updateGestureScale

            }.onEnded { value in
                isGesturing = false
            })
    }
}

#Preview(immersionStyle: .automatic) {
    ScaleToAnyEntity()
}
