//
//  ImmersiveView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import SwiftUI

struct RotateToAnyEntity: View {

    @State private var currentRotation:  simd_quatf = simd_quatf()

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
            RotationGesture().targetedToAnyEntity().onChanged { value in

                if isGesturing == false {
                    currentRotation = value.entity.transform.rotation
                    isGesturing = true
                }

                let updateGestureAngle = Float(value.gestureValue.radians)
                
                var axis = SIMD3<Float>(0,0,1)
                
                if value.entity.name == "blue"{
                    axis = SIMD3<Float>(1,0,0)
                } else if value.entity.name == "red"{
                    axis = SIMD3<Float>(0,1,0)
                }

                value.entity.transform.rotation = currentRotation*simd_quatf(
                    angle: updateGestureAngle,
                    axis: axis
                )

            }.onEnded { value in
                isGesturing = false
            })
    }
}

#Preview(immersionStyle: .automatic) {
    RotateToAnyEntity()
}
