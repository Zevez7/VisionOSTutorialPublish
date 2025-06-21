//
//  ImmersiveView.swift
//  GestureControl
//
//  Created by Dat Nguyen on 12/20/24.
//

import RealityKit
import SwiftUI

struct ComboToAnyEntity: View {

    @State private var currentScale:  SIMD3<Float> = SIMD3<Float>(0,0,0)
    @State private var currentPosition:  SIMD3<Float> = SIMD3<Float>(0,0,0)

    @State private var isGesturing: Bool = false

    var gestureClass = GestureClass()
    
    func Magnify() -> some Gesture{
        MagnifyGesture().targetedToAnyEntity().onChanged { value in

            if isGesturing == false {
                currentScale = value.entity.transform.scale
                isGesturing = true
            }

            let updateGestureScale = Float(value.gestureValue.magnification)

            value.entity.scale = currentScale * updateGestureScale

        }.onEnded { value in
            isGesturing = false
        }
    }
    
    func Drag() -> some Gesture{
        DragGesture().targetedToAnyEntity().onChanged { value in

            if isGesturing == false {
                currentPosition = value.entity.position
                isGesturing = true
            }

            let gestureTranslation = value.convert(
                value.gestureValue.translation3D, from: .local, to: .scene)

            value.entity.position =
            currentPosition
                + gestureTranslation

        }.onEnded { value in
            isGesturing = false
        }
    }
    
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
            SimultaneousGesture(Magnify(), Drag())
         )
    }
}

#Preview(immersionStyle: .automatic) {
    ComboToAnyEntity()
}
